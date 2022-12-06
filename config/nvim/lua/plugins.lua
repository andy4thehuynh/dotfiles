return require("packer").startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  use {
    "jayp0521/mason-null-ls.nvim",
    "jose-elias-alvarez/null-ls.nvim",
  }

  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
      { 'kyazdani42/nvim-web-devicons' },
    }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'RRethy/nvim-treesitter-endwise',
      'p00f/nvim-ts-rainbow'
    },
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }

  use {
    'yamatsum/nvim-nonicons',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  use {
    'hrsh7th/cmp-cmdline',
    requires = {'hrsh7th/cmp-buffer'}
  }

  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use {
    'windwp/nvim-autopairs',
    config = function() require("nvim-autopairs").setup {} end
  }

  use {
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function() require("nvim-surround").setup({}) end
  }

  use {
    'knubie/vim-kitty-navigator',
    run = "cp ./*.py ~/.config/kitty/"
  }
use { "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "kyazdani42/nvim-web-devicons",
    }
  }

  use {
    'renerocksai/telekasten.nvim',
    requires = {
      'nvim-telescope/telescope-symbols.nvim',
      'renerocksai/calendar-vim',

      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
    }
  }

  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "olimorris/neotest-rspec",
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-rspec')({
            rspec_cmd = function()
              return vim.tbl_flatten({
                "bundle",
                "exec",
                "rspec",
              })
            end
          }),
        }
      })
    end
  }

  use {
    'KadoBOT/nvim-spotify',
    requires = 'nvim-telescope/telescope.nvim',
    config = function()
      local spotify = require'nvim-spotify'

      spotify.setup {
        -- default opts
        status = {
          update_interval = 10000, -- the interval (ms) to check for what's currently playing
          format = '%a | %t' -- spotify-tui --format argument
        }
      }
    end,
    run = 'make'
  }

  use 'kyazdani42/nvim-web-devicons'
  use 'kdheepak/lazygit.nvim'
  use 'shaunsingh/nord.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'junegunn/vim-easy-align'
  use 'onsails/lspkind.nvim'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
end)
