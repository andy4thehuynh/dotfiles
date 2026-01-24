return {
  -- Add ruby_lsp to Mason and configure it
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {},
      },
    },
  },

  -- Add Ruby treesitter parser for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ruby" },
    },
  },
}
