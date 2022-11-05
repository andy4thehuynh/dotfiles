local servers = { "solargraph", "gopls", "tsserver" }
local lspkind = require('lspkind')
local cmp = require('cmp')

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = servers
})


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


-- Completion configuration
cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      before = function(_, vim_item)
        return vim_item
      end
    })
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete({}),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<TAB>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'spell' },
  }),
  experimental = {
    ghost_text = true
  },
})

-- for nvim_lsp_document_symbol
cmp.setup.cmdline('/', {
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' }
  }, {
    { name = 'buffer' }
  })
})

-- for cmp_autopairs
-- cmp.event:on(
--   'confirm_done',
--   cmp_autopairs.on_confirm_done()
-- )

vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references
