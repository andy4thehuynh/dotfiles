local function map(mode, lhs, rhs, opts)
  if opts == nil then
    opts = {}
  end

  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end


-- Reloads Neovim
map("", "<leader><leader>", ":source $MYVIMRC<cr>")

-- Splitting windows
map("", "<leader>-", ":split<cr>")
map("", "<leader>l", ":vsplit<cr>")

-- Split Navigation
map("n", "<C-J>", "<C-W><C-J>", { noremap = true })
map("n", "<C-K>", "<C-W><C-K>", { noremap = true })
map("n", "<C-L>", "<C-W><C-L>", { noremap = true })
map("n", "<C-H>", "<C-W><C-H>", { noremap = true })

-- NvimTree
map("", "<leader>n", ":NvimTreeToggle<cr>")

-- LazyGit
map("n", "<C-G>", ":LazyGitFilterCurrentFile<cr>", { noremap = true })

-- Telescope
map("n", "<C-P>", ":Telescope find_files<cr>")

-- Gitsigns config
map("n", "<leader>b", ":Gitsigns toggle_current_line_blame<cr>")
