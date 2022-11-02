local g = vim.g
local set = vim.api.nvim_set_option

-- disable netrw at the very start of your init.lua (strongly advised)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Basic Options
set("swapfile", false)       -- disable unnecessary temp storage file
set("number", true)          -- enable number lines
set("expandtab", true)       -- inserts space chars for tabkey
set("relativenumber", true)  -- numbers are relative to cursor position
set("ignorecase", true)      -- case insensitive searches
set("compatible", false)     -- turns on features of old Vi; compatibility with old Vi

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
