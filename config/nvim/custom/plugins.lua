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
        "ruby-lsp",
        "typescript-language-server",
      },
    }
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      'RRethy/nvim-treesitter-endwise',
      'andymass/vim-matchup',
    },
    opts = {
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
      indent = {
        enable = false,
      },
      endwise = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
      matchup = {
        enable = true,
      },
    }
  },

  {
    'andymass/vim-matchup',
    config = function()
      vim.g.matchup_matchparen_deferred = 1
    end,
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

  { 'metakirby5/codi.vim', lazy = false },
  { 'tpope/vim-rails', lazy = false },
  { 'tpope/vim-dispatch', lazy = false },
  { "AndrewRadev/splitjoin.vim", event = 'VeryLazy' },
  { "tpope/vim-fugitive", event = 'VeryLazy' },
  { 'windwp/nvim-ts-autotag', event = 'VeryLazy' },
  { 'hallison/vim-rdoc', event = 'VeryLazy' },
}
return plugins
