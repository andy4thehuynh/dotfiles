vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>lua require('neotest').run.run()<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>L", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", {})
