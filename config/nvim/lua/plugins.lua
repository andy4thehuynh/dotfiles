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
  -- use 'onsails/lspkind.nvim'

  -- LSP Plugins
  -- use 'lukas-reineke/lsp-format.nvim'
  -- use 'f3fora/cmp-spell'
  -- use 'folke/lsp-colors.nvim'
  -- use 'hrsh7th/cmp-nvim-lsp-document-symbol'

  -- General Plugins
  use 'kyazdani42/nvim-web-devicons'
	use 'Mofiqul/dracula.nvim'
  use 'fladson/vim-kitty'
	use 'kdheepak/lazygit.nvim'
  use 'tpope/vim-endwise'
  use 'tpope/vim-rails'
  use 'vim-ruby/vim-ruby'


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
		'lewis6991/gitsigns.nvim',
		config = function() require('gitsigns').setup() end
	}
end)
