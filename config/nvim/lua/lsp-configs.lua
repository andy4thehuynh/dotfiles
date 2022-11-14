---
-- Global Config
---

local config = require("lspconfig")
local lsp_defaults = config.util.default_config
-- local servers = { "solargraph", "gopls", "tsserver" }

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "solargraph" }
})

lsp_defaults.capabilities = vim.tbl_deep_extend(
  "force",
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)

---
-- LSP Servers
---

config.solargraph.setup({})


-- for _, server in pairs(servers) do
--   config[server].setup {
--     -- capabilities = defaultCapabilities,
--   }
-- end
--
--
-- -- longer updatetime (default is 4000 ms = 4 s) leads to delays
-- vim.o.updatetime = 250
--
--
vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references
--
--
-- vim.diagnostic.config({
--   virtual_text = false,
-- })
