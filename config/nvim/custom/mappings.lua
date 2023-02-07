---@type MappingsConfig
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>n"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },
    ["<C-G>"] = { ":LazyGit<CR>", "open LazyGit", opts = { noremap = true } },
  },
}

-- more keybinds!

return M
