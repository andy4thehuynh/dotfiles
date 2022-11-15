return require("packer").startup(function()
  use 'wbthomason/packer.nvim'

  -- LSP server manager and its necessary plugins
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'saadparwaiz1/cmp_luasnip'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'

  use 'hrsh7th/cmp-cmdline'
  use 'lukas-reineke/indent-blankline.nvim'

  -- General Plugins
  use 'kyazdani42/nvim-web-devicons'
	use 'Mofiqul/dracula.nvim'
  use 'fladson/vim-kitty'
	use 'kdheepak/lazygit.nvim'
  use 'tpope/vim-endwise'
  use 'tpope/vim-rails'
  use 'vim-ruby/vim-ruby'
  use 'f-person/git-blame.nvim'


  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }


  use {
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function() require("nvim-surround").setup({}) end
  }


  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end
  }


  use {
    'windwp/nvim-autopairs',
    config = function() require("nvim-autopairs").setup {} end
  }


	use {
    'knubie/vim-kitty-navigator',
    run = "cp ./*.py ~/.config/kitty/"
  }


	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}


  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }


	use {
		'nvim-telescope/telescope.nvim', -- github version of telescope
		requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
      { 'kyazdani42/nvim-web-devicons' }
    }
  }


  use {
    'yamatsum/nvim-nonicons',
    requires = {'kyazdani42/nvim-web-devicons'}
  }


  use {
    "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "kyazdani42/nvim-web-devicons",
    }
  }
end)
