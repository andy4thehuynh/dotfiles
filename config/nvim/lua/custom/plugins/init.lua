-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

local M = {}

M.plugins = {
  {
    "AndrewRadev/splitjoin.vim",
    -- Will not load on startup, but only when used
    event = 'VeryLazy',
  },

  -- File Browsing
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = {
      vim.keymap.set('n', '<C-P>', ":Neotree toggle<CR>", { desc = 'Toggle File Browser' })
    }
  },
}

return M.plugins
