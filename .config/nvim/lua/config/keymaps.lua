-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Claude Code inline transformation
vim.api.nvim_create_user_command('ClaudeTransform', function(opts)
  local prompt = vim.fn.input('Task: ')
  if prompt ~= '' then
    local filetype = vim.bo.filetype
    local context = filetype ~= '' and ' (this is ' .. filetype .. ' code)' or ''
    local full_prompt = prompt .. context .. '. Output only the transformed code, no explanation or formatting.'
    local escaped_prompt = vim.fn.shellescape(full_prompt)
    local cmd = opts.line1 .. ',' .. opts.line2 .. '!claude --model haiku --dangerously-skip-permissions -p ' .. escaped_prompt .. " 2>/dev/null | sed '/^\\`\\`\\`.*$/d'"
    vim.cmd(cmd)
    vim.notify('Code transformed', vim.log.levels.INFO)
  else
    vim.notify('Transformation cancelled', vim.log.levels.WARN)
  end
end, { range = true })

vim.keymap.set('v', '<leader>ai', ':ClaudeTransform<CR>',
  { noremap = true, silent = true, desc = "AI transform selection (Claude)" })
