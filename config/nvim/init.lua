--[[
    The following configurations have been confirmed not to play nice with vscode-neovim:

    ⛔ vim.opt.scrolloff = 10
    ⛔ formatting keymap '='
--]]

vim.g.mapleader = " "

-- Check if we're in VSCode context
if vim.g.vscode then
  vim.schedule(function() -- delay print so it appears after UI is ready
    print("✅ VSCode Neovim integration loaded!")
  end)

  -- Set options safe for VSCode
  vim.opt.clipboard = "unnamedplus" -- Use system clipboard
  vim.opt.number = true -- Show line numbers
  vim.opt.ignorecase = true -- ignore case in search patterns
  vim.opt.smartcase = true -- override ignorecase if search contains uppercase

  local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
  end

  -- veritcal split
  map("n", "\\\\", function()
    vim.fn.VSCodeNotify("workbench.action.splitEditorRight")
  end, { desc = "Split Editor Right" })

  -- horizontal split
  map("n", "\\-", function()
    vim.fn.VSCodeNotify("workbench.action.splitEditorDown")
  end, { desc = "Split Editor Down" })

  -- pane navigation
  map("n", "<C-h>", function()
    vim.fn.VSCodeNotify("workbench.action.focusLeftGroup")
  end, { desc = "Focus Left Pane" })
  map("n", "<C-l>", function()
    vim.fn.VSCodeNotify("workbench.action.focusRightGroup")
  end, { desc = "Focus Right Pane" })
  map("n", "<C-k>", function()
    vim.fn.VSCodeNotify("workbench.action.focusAboveGroup")
  end, { desc = "Focus Upper Pane" })
  map("n", "<C-j>", function()
    vim.fn.VSCodeNotify("workbench.action.focusBelowGroup")
  end, { desc = "Focus Lower Pane" })
else
  -- bootstrap lazy.nvim, LazyVim and your plugins
  require("config.lazy")
  print('Neovim loaded!')
end