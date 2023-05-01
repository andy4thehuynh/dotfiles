local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

local servers = {
  "astro",
  "lua_ls",
  "ruby_ls",
  "solargraph",
  "tailwindcss",
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

  solargraph = {
    cmd = { 'solargraph', 'stdio' },
    filetypes = { 'ruby' },
    root_dir = lspconfig.util.root_pattern('.git'),
    -- waits to generate suggestions to not overload Solargraph
    flags = { debounce_text_changes = 150, },
  },
}


local defaults = {
  on_attach = on_attach,
  capabilities = capabilities,
}

for _, server in ipairs(servers) do
  lspconfig[server].setup(merge(defaults, overrides[server]))
end
