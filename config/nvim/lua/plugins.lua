return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  -- use {
  --   'knubie/vim-kitty-navigator',
  --   run = "cp ./*.py ~/.config/kitty/"
  -- }

  -- use {
  --   'nvim-lualine/lualine.nvim',
  --   requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  -- }

  -- use {
  --   'nvim-telescope/telescope.nvim', -- github version of telescope
  --   -- '~/code/telescope.nvim', -- local version of telescope
  --   requires = { { 'nvim-lua/plenary.nvim' } }
  -- }

  -- use({
  --   "iamcco/markdown-preview.nvim",
  --   run = function() vim.fn["mkdp#util#install"]() end,
  -- })

  -- use {
  --   'phaazon/hop.nvim',
  --   branch = 'v1', -- optional but strongly recommended
  -- }

  -- use {
  --   'kyazdani42/nvim-tree.lua',
  --   requires = {
  --     'kyazdani42/nvim-web-devicons', -- optional, for file icon
  --   },
  --   tag = 'nightly' -- optional, updated every week. (see issue #1193)
  -- }

  -- use {
  --   'yamatsum/nvim-nonicons',
  --   requires = { 'kyazdani42/nvim-web-devicons' }
  -- }
end)
