local autocmd = vim.api.nvim_create_autocmd
local g = vim.g

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- sets leader command to backslash
g.mapleader = "\\"

-- g.luasnippets_path = "your snippets path"
