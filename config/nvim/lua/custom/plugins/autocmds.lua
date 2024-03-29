-- autocmds.lua
--
--
-- Actions that Neovim should automatically execute in response to specific events or conditions

-- Treat Brewfile as a ruby file
local brewfile = vim.api.nvim_create_augroup("Brewfile", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "BrewFile" },
  callback = function()
    vim.api.nvim_buf_set_option(0, "syntax", "ruby")
    vim.api.nvim_buf_set_option(0, "filetype", "ruby")
  end,
  group = brewfile
})

-- Opens Neovim at last position when reopening a file
vim.cmd([[
  if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
  endif
]])

return {}

