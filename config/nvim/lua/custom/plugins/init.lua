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
}

return M.plugins
