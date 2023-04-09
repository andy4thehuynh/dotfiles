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

  {
    "tpope/vim-rails",
    ft = "ruby",
    config = function()
      vim.g.rails_detect_filetype = 1
    end
  },

  {
    "vim-ruby/vim-ruby",
    ft = "ruby",
    config = function()
      vim.g.rubycomplete_buffer_loading = 1
      vim.g.rubycomplete_classes_in_global = 1
      vim.g.rubycomplete_rails = 1
    end,
  },

  {
    "tpope/vim-endwise",
    ft = "ruby",
  },

  {
    "tpope/vim-fugitive",
    cmd = "Git"
  },
}
return plugins
