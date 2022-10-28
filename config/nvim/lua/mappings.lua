local function map(mode, lhs, rhs, opts)
  if opts == nil then
    opts = {}
  end

  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

-- NvimTree
map("", "<C-e>", ":NvimTreeToggle<cr>")
map("", "<leader>n", ":NvimTreeToggle<cr>")
map("", "<leader>f", ":NvimTreeFindFile<cr>")
