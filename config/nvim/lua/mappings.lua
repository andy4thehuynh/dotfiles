local function map(mode, lhs, rhs, opts)
  if opts == nil then
    opts = {}
  end

  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

-- Splitting windows
map("", "<leader>-", ":split<cr>")
map("", "<leader><leader>", ":vsplit<cr>")

-- Split Navigation
map("n", "<C-J>", "<C-W><C-J>", { noremap = true })
map("n", "<C-K>", "<C-W><C-K>", { noremap = true })
map("n", "<C-L>", "<C-W><C-L>", { noremap = true })
map("n", "<C-H>", "<C-W><C-H>", { noremap = true })

-- Packer
map("", "<leader>pi", ":PackerSync<cr>")
map("", "<leader>ps", ":PackerStatus<cr>")

-- LazyGit
map("n", "<C-G>", ":LazyGit<cr>", { noremap = true })

-- Vim-easy-align
vim.cmd [[
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
]]

-- -- nvim-dap
-- map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>") -- launches session or resume execution
-- map("n", "<leader>dd", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
-- map("n", "<leader>df", "<cmd>lua require'dap'.repl.open()<cr>")
-- map("n", "<leader>dv", "<cmd>lua require'dapui'.toggle()<cr>")
