local plugins = {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "astro-language-server",
        "lua-language-server",
        "solargraph",
        "tailwindcss-language-server",
        "typescript-language-server",
      },
    }
  },

  { "tpope/vim-fugitive" },
}
return plugins
