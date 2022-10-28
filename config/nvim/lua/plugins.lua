return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

	use 'kdheepak/lazygit.nvim'
	use 'tpope/vim-commentary'
	use 'Mofiqul/dracula.nvim'
	use 'kyazdani42/nvim-web-devicons' -- dependency for Telescope, Nvim-tree
	use 'nvim-treesitter/nvim-treesitter' -- dependency for Telescope

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

	use {
		'nvim-telescope/telescope.nvim', -- github version of telescope
		-- '~/code/telescope.nvim', -- local version of telescope
		requires = { { 'nvim-lua/plenary.nvim' } }
  }
end)
