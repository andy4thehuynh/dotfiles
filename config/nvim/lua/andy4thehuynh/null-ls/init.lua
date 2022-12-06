require("mason").setup()
local null_ls = require("null-ls")

local sources = {
  null_ls.builtins.completion.luasnip,
  null_ls.builtins.diagnostics.spellcheck,
  null_ls.builtins.formatting.prettier,
  null_ls.builtins.diagnostics.standardrb,
  null_ls.builtins.formatting.standardrb,
  null_ls.builtins.formatting.stylua,
}

null_ls.setup({ sources = sources, debug = true })

-- Primary Source of Truth is null-ls: https://github.com/jay-babu/mason-null-ls.nvim
require("mason-null-ls").setup({
  ensure_installed = nil,
  automatic_installation = true,
  automatic_setup = true,
})
