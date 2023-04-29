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
        "ruby-lsp",
        "typescript-language-server",
      },
    }
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { 'RRethy/nvim-treesitter-endwise' },
    opts = {
      indent = {
        enable = false,
      },
      ensure_installed = {
        "astro",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "ruby",
        "scss",
        "typescript",
        "yaml",
      },
      endwise = {
        enable = true,
      },
    }
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      renderer = {
        icons = {
          show = {
            git = false,
          },
        },
        indent_markers = {
          enable = true
        }
      },
      view = {
        mappings = {
          list = {
            { key = "s", action = "split" },
            { key = "i", action = "vsplit" },
            { key = "?", action = "toggle_help" },
          }
        }
      },
    },
  },


  {
    "themaxmarchuk/tailwindcss-colors.nvim",
    config = function ()
      require("tailwindcss-colors").setup()
    end
  },

  { "AndrewRadev/splitjoin.vim", event = 'VeryLazy' },
  { "tpope/vim-fugitive", event = 'VeryLazy' },
  { 'tpope/vim-rails', lazy = false },
}
return plugins
