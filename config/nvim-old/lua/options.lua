--
-- Basic Options
--
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.number = true -- show line numbers in the gutter
vim.opt.smartcase = true  -- case-insensitive if you only use lowercase letters;
vim.opt.laststatus = 2 -- display status line on startup
vim.opt.relativenumber = true  -- shows lines numbers heliocentric from current one
vim.opt.swapfile = false  -- disable creation of Vim .swp files
vim.opt.ignorecase = true -- all searches will be case insensitive
vim.opt.hidden = true -- hide unused buffers
vim.opt.backup = false  -- disables creation of backup files
vim.opt.writebackup = false  -- disable backup writes of a current file
vim.opt.shell = "/bin/zsh"  -- sets shell for Vim
vim.opt.scrolloff = 10 --  minimal number of screen lines to keep above and below the cursor
vim.opt.hlsearch = true -- highlights search patterns
vim.opt.wrap = true -- ensures text visibility stays within the window
vim.opt.wildmenu = true -- shows a more advanced menu for autocomplete suggestions
vim.opt.wildmode = "list:longest" -- displays completion mode
vim.opt.clipboard = "unnamed,unnamedplus"

vim.opt.termguicolors = true -- expands usable colors, if terminal supports it
vim.cmd[[colorscheme nord]]
