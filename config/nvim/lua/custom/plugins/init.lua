-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

local M = {}

M.plugins = {
  {
    -- Interactive scratchpad
    "metakirby5/codi.vim",
    -- Will not load on startup, only when used
    event = { "VeryLazy" },
    config = function()
      vim.keymap.set('n', '\\c', ":Codi!!<CR>", { desc = 'Toggle Codi scratchpad' })
    end
  },

  {
    -- Allows navigation between Neovim and Kitty
    'knubie/vim-kitty-navigator',
    lazy = false,
    build = "cp ./*.py ~/.config/kitty/"
  },

  {
    -- File Browsing
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = {
      -- Toggles Neotree focused on current buffer
      vim.keymap.set('n', '<C-P>', ":Neotree toggle reveal<CR>", { desc = 'Toggle File Browser' })
    }
  },


  -- [[ Editing text ]]
  {
    -- Keystrokes to change surrounding brackets, parenthesis, tags, quotes + more
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },

  {
    -- Keystrokes to split and join a block of code
    "AndrewRadev/splitjoin.vim",
    -- Will not load on startup, only when used
    event = 'VeryLazy',
  },

  {
    -- Inserts matching pairs of characters (such as brackets, parentheses, quotes)
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },
}

return M.plugins
