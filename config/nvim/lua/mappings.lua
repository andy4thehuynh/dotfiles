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


-- Reloads Neovim
map("", "<leader>r", ":source $MYVIMRC<cr>")


-- NvimTree
map("", "<leader>n", ":NvimTreeToggle<cr>")


-- GitBlame
map("n", "<leader>b", ":GitBlameToggle<cr>")


-- Packer
map("", "<leader>ps", ":PackerSync<cr>")


-- LazyGit
map("n", "<C-G>", ":LazyGit<cr>", { noremap = true })


-- Telescope
map("n", "<C-P>", ":Telescope find_files<cr>")
map("n", "<C-/>", ":Telescope live_grep<cr>")
map("n", "<C-d>", ":Telescope diagnostics<cr>")
map("n", "<C-;>", ":Telescope help_tags<cr>")


-- Neotest
map("n", "<leader>l", "<cmd>lua require('neotest').run.run()<cr>") -- Runs line
map("n", "<leader>L", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>") -- Runs file


-- Vim-easy-align
vim.cmd [[
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
]]


-- Lsp mappings
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Displays hover information about the symbol under the cursor
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Displays a function's signature information
    bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Move to the previous diagnostic
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

    -- Move to the next diagnostic
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

-- Bufferline (tab navigation and management)
vim.cmd[[
  nnoremap <silent>bp :tabnew<CR>
  nnoremap <silent>b] :BufferLineCycleNext<CR>
  nnoremap <silent>b[ :BufferLineCyclePrev<CR>
  nnoremap <silent>b<leader> :BufferLinePickClose<CR>
]]

