vim.opt.swapfile = false  -- disable creation of Vim .swp files
vim.opt.backup = false
vim.opt.wrap = true -- ensures text visibility stays within the window
vim.opt.hidden = true -- hide unused buffers
vim.opt.smartcase = true  -- case-insensitive if you only use lowercase letters;
vim.opt.smartindent = true

vim.opt.nu = true
vim.opt.relativenumber = true  -- shows lines numbers heliocentric from current one
vim.opt.scrolloff = 10 --  minimal number of screen lines to keep above and below the cursor

vim.opt.hlsearch = true -- highlights search patterns
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.lsp.set_log_level 'debug'

-- Formats debug logs as multiline/json
if vim.fn.has 'nvim-0.5.1' == 1 then
  require('vim.lsp.log').set_format_func(vim.inspect)
end
