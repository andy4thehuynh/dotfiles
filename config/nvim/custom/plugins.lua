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

  {
    "themaxmarchuk/tailwindcss-colors.nvim",
    config = function ()
      require("tailwindcss-colors").setup()
    end
  },

  {
    "AndrewRadev/splitjoin.vim",
    lazy = false,
  },
}
return plugins
