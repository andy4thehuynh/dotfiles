---@type MappingsConfig
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>n"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },
  },
}

-- more keybinds!

return M
