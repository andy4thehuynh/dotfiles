---
-- Global Config
---

local config = require("lspconfig")
local lsp_defaults = config.util.default_config

require("mason").setup()
require("mason-lspconfig").setup()
lsp_defaults.capabilities = vim.tbl_deep_extend(
  "force",
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)


---
-- LSP Servers
---

config.solargraph.setup({})
config.tsserver.setup({})
config.gopls.setup({})
config.sumneko_lua.setup({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})


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
