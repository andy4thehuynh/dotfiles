local autocmd = vim.api.nvim_create_autocmd
local global = vim.g
local opts = vim.opt

opts.swapfile = false  -- disable creation of Vim .swp files
opts.backup = false
opts.wrap = true -- ensures text visibility stays within the window
opts.hlsearch = true -- highlights search patterns
opts.hidden = true -- hide unused buffers
opts.smartcase = true  -- case-insensitive if you only use lowercase letters;
opts.smartindent = true
opts.nu = true
opts.relativenumber = true  -- shows lines numbers heliocentric from current one
opts.scrolloff = 10 --  minimal number of screen lines to keep above and below the cursor
opts.hlsearch = false
opts.incsearch = true
opts.termguicolors = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

global.mapleader = "\\"
