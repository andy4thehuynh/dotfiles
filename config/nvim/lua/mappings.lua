local function map(mode, lhs, rhs, opts)
  if opts == nil then
    opts = {}
  end

  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

-- Splitting windows
map("", "<leader>-", ":split<cr>")
map("", "<leader><bar>", ":vsplit<cr>")

-- Split Navigation
map("n", "<C-J>", "<C-W><C-J>", { noremap = true })
map("n", "<C-K>", "<C-W><C-K>", { noremap = true })
map("n", "<C-L>", "<C-W><C-L>", { noremap = true })
map("n", "<C-H>", "<C-W><C-H>", { noremap = true })

-- NvimTree
map("", "<C-e>", ":NvimTreeToggle<cr>")
map("", "<leader>n", ":NvimTreeToggle<cr>")
map("", "<leader>f", ":NvimTreeFindFile<cr>")

-- LazyGit
map("n", "<C-G>", ":LazyGit<CR>", { noremap = true })

-- Telescope
map("n", "<C-P>", ":Telescope find_files<cr>")
