local servers = { "solargraph", "gopls", "tsserver" }

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = servers
})

require('cmp').setup {
  sources = {
    { name = 'nvim_lsp' }
  }
}

require("lsp-format").setup {}

local config = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_flags = {
  debounce_text_changes = 150,   -- This is the default in Nvim 0.7+
}

for _, server in pairs(servers) do
  config[server].setup {
    capabilities = capabilities,
    settings = settings,
    on_attach = require("lsp-format").on_attach
  }
end

vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references
