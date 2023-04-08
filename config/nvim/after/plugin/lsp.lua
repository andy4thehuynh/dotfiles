local lsp = require('lsp-zero').preset({})

-- remaps only live for the 
lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({buffer = bufnr})

	local opts = {buffer = bufnr, remap = false}
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<leader>vsh", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.ensure_installed({
	'eslint',
	'lua_ls',
	'ruby_ls',
	'tailwindcss',
	'tsserver',
})

local cmp = require('cmp')
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

lsp.setup()

vim.diagnostic.config({
	virtual_text = true
})
