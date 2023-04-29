local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

local servers = {
  "astro",
  "lua_ls",
  "tailwindcss",
  "ruby_ls",
  "tsserver",
}

vim.diagnostic.config { virtual_text = false }

local function merge(t1, t2)
  if not t2 then return t1 end
  return vim.tbl_extend('force', t1, t2)
end

local overrides = {
  ruby_ls = {
    on_attach = function(client, bufnr)

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePre', 'CursorHold' }, {
        buffer = bufnr,

        callback = function()
          local params = vim.lsp.util.make_text_document_params(bufnr)

          client.request(
            'textDocument/diagnostic',
            { textDocument = params },
            function(err, result)
              if err then return end
              if not result then return end

              vim.lsp.diagnostic.on_publish_diagnostics(
                nil,
                vim.tbl_extend('keep', params, { diagnostics = result.items }),
                { client_id = client.id }
              )
            end
          )
        end,
      })
    end,
  },

  tailwindcss = {
    on_attach = function(_, bufnr)
      require("tailwindcss-colors").buf_attach(bufnr)
    end
  },
}

local defaults = {
  on_attach = on_attach,
  capabilities = capabilities,
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup(merge(defaults, overrides[lsp]))
end
