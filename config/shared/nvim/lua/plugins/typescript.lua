return {
  -- TypeScript/JavaScript LSP (handles React JSX/TSX natively)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {},
        volar = {}, -- Vue.js support
      },
    },
  },

  -- Treesitter parsers for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "typescript",
        "tsx",
        "javascript",
        "vue",
      },
    },
  },
}
