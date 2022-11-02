return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

	use 'Mofiqul/dracula.nvim'
  use "fladson/vim-kitty"
	use 'kdheepak/lazygit.nvim'
	use 'tpope/vim-commentary'
  use 'kyazdani42/nvim-web-devicons'


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
		config = function()
			require('gitsigns').setup()
		end
	}
end)
