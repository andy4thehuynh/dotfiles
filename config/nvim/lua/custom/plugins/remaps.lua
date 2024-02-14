-- remaps.lua
--
--
-- Mostly window management and navigation

vim.keymap.set('n', ';', ":", { desc = 'enter command mode' })
vim.keymap.set('n', '\\-', ":split<cr>", { desc = 'splits vim pane horizontally' })
vim.keymap.set('n', '\\\\', ":vsplit<cr>", { desc = 'splits vim pane vertically' })

-- Navigate Vim panes
vim.keymap.set('n', '<C-h>', "<C-w>h", { desc = 'move window left' })
vim.keymap.set('n', '<C-j>', "<C-w>j", { desc = 'move window down' })
vim.keymap.set('n', '<C-k>', "<C-w>k", { desc = 'move window up' })
vim.keymap.set('n', '<C-l>', "<C-w>l", { desc = 'move window right' })

-- diffview plugin
vim.keymap.set('n', '\\do', ":DiffviewOpen<cr>", { desc = 'opens diffview' })
vim.keymap.set('n', '\\dc', ":DiffviewClose<cr>", { desc = 'closes diffview' })


return {}
