local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local servers = {
  "astro",
  "cssls",
  "emmet_ls",
  "html",
  "lua_ls",
  "tailwindcss",
  "tsserver",
}

for _, lsp in ipairs(servers) do
  -- Sets up tailwindcss colors
  if lsp == "tailwindcss" then
    on_attach = function (_, bufnr)
      require('tailwindcss-colors').buf_attach(bufnr)
    end
  end

  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- fixes `lsp client log is large error` by disabling
-- LSP client log level
vim.lsp.set_log_level("off")
