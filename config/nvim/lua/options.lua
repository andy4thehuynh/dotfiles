local g = vim.g
local set = vim.api.nvim_set_option

-- Basic Options
set("swapfile", false)
set("expandtab", true)
set("relativenumber", true)
set("ignorecase", true)
set("compatible", false)
set("showcmd", true)
set("showmode", true)
set("hidden", true)
set("wildmenu", true)
set("wildmode", "list:longest")
set("smartcase", true)
set("incsearch", true)
set("hlsearch", true)
set("wrap", true)
set("scrolloff", 10)
set("ruler", true)
set("title", true)
set("backup", false)
set("writebackup", false)
set("expandtab", true)
set("laststatus", 2)
set("shiftwidth", 2)
set("tabstop", 2)
set("completeopt", "menu,menuone,noselect")

set("shell", "/bin/bash")

vim.o.termguicolors = true

vim.cmd [[
  set clipboard+=unnamedplus
]]

-- Set colorscheme
vim.cmd[[colorscheme dracula]]
