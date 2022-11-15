local function map(mode, lhs, rhs, opts)
  if opts == nil then
    opts = {}
  end

  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end


-- Splitting windows
map("", "<leader>-", ":split<cr>")
map("", "<leader>l", ":vsplit<cr>")


-- Split Navigation
map("n", "<C-J>", "<C-W><C-J>", { noremap = true })
map("n", "<C-K>", "<C-W><C-K>", { noremap = true })
map("n", "<C-L>", "<C-W><C-L>", { noremap = true })
map("n", "<C-H>", "<C-W><C-H>", { noremap = true })


-- Create new tabs
map("n", "<leader>t", ":tabnew<cr>")


-- Reloads Neovim
map("", "<leader><leader>", ":source $MYVIMRC<cr>")


-- NvimTree
map("", "<leader>n", ":NvimTreeToggle<cr>")


-- GitBlame
map("n", "<leader>b", ":GitBlameToggle<cr>")


-- PackerSync
map("", "<C-S>", ":PackerSync<cr>")


-- LazyGit
map("n", "<C-G>", ":LazyGitFilterCurrentFile<cr>", { noremap = true })


-- Telescope
map("n", "<C-F>", ":Telescope find_files<cr>")
map("n", "<C-P>", ":Telescope live_grep<cr>")


-- Barbar
local barbar_opts = { noremap = true, silent = true }
map('n', '<leader>]', '<Cmd>BufferNext<CR>', barbar_opts)
map('n', '<leader>[', '<Cmd>BufferPrevious<CR>', barbar_opts) -- Move to previous/next
map('n', '<leader>q', '<Cmd>BufferClose<CR>', barbar_opts) -- Close a buffer
