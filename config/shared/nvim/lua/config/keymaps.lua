-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Returns { cmd_prefix, label } based on $NVIM_AI_ASSISTANT (default: claude)
-- Set NVIM_AI_ASSISTANT=agy in your ~/.bashrc to switch to antigravity-cli
local function get_ai_config()
  local assistant = vim.env.NVIM_AI_ASSISTANT or "claude"
  if assistant == "agy" then
    return {
      -- agy uses the same -p / --dangerously-skip-permissions interface as claude
      prefix = "agy --dangerously-skip-permissions -p",
      label = "Antigravity",
    }
  end
  return {
    prefix = "claude --model haiku --dangerously-skip-permissions -p",
    label = "Claude",
  }
end

local function open_floating_window(lines, title)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false

  local width = math.min(80, vim.o.columns - 4)
  local height = math.min(#lines + 2, vim.o.lines - 4)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
  })

  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true

  vim.keymap.set("n", "q", ":close<CR>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = buf, silent = true })
end

local function show_ai_explanation(output, label)
  while #output > 0 and output[#output] == "" do
    table.remove(output)
  end

  if #output == 0 then
    vim.notify("No response from " .. label .. ".\nReview vim logs for warnings!", vim.log.levels.WARN)
    return
  end

  open_floating_window(output, " " .. label .. " Explanation ")
end

-------------------------------------------
-- AI explain selection
-------------------------------------------
vim.api.nvim_create_user_command("ClaudeExplain", function(opts)
  local ai = get_ai_config()
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  local code = table.concat(lines, "\n")
  local filetype = vim.bo.filetype
  local context = filetype ~= "" and " (this is " .. filetype .. " code)" or ""
  local prompt = "Explain what this code does" .. context .. ": \n\n" .. code
  local escaped_prompt = vim.fn.shellescape(prompt)
  local cmd = ai.prefix .. " " .. escaped_prompt .. " </dev/null 2>&1"

  vim.notify("Asking " .. ai.label .. "...", vim.log.levels.INFO)

  local output = {}
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        output = data
      end
    end,
    on_exit = function()
      vim.schedule(function()
        show_ai_explanation(output, ai.label)
      end)
    end,
  })
end, { range = true })

vim.keymap.set(
  "v",
  "<leader>ae",
  ":ClaudeExplain<CR>",
  { noremap = true, silent = true, desc = "AI explain selection" }
)

-------------------------------------------
-- AI inline transformation
-------------------------------------------
vim.api.nvim_create_user_command("ClaudeTransform", function(opts)
  local ai = get_ai_config()
  local prompt = vim.fn.input("Task: ")
  if prompt ~= "" then
    local filetype = vim.bo.filetype
    local context = filetype ~= "" and " (this is " .. filetype .. " code)" or ""
    local full_prompt = prompt .. context .. ". Output only the transformed code, no explanation or formatting."
    local escaped_prompt = vim.fn.shellescape(full_prompt)
    local cmd = opts.line1
      .. ","
      .. opts.line2
      .. "!" .. ai.prefix .. " "
      .. escaped_prompt
      .. " 2>/dev/null | sed '/^\\`\\`\\`.*$/d'"
    vim.cmd(cmd)
    vim.notify("Code transformed by " .. ai.label, vim.log.levels.INFO)
  else
    vim.notify("Transformation cancelled", vim.log.levels.WARN)
  end
end, { range = true })

vim.keymap.set(
  "v",
  "<leader>ai",
  ":ClaudeTransform<CR>",
  { noremap = true, silent = true, desc = "AI transform selection" }
)
