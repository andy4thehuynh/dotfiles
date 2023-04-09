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

for _, lsp in ipairs(servers) do
  -- sets up tailwind colors
  if lsp == "tailwindcss" then
    on_attach = function(_, bufnr)
      require("tailwindcss-colors").buf_attach(bufnr)
    end
  end

  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities
  })
end

-- fixes `lsp client log is large error` by disabling
-- LSP client log level
vim.lsp.set_log_level("off")
