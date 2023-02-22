---@type MappingsConfig
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>n"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
    ["<C-G>"] = { ":LazyGit<CR>", "open LazyGit", opts = { noremap = true } },
    ["<leader>-"] = { ":split<cr>", "splits vim pane horizontally" },
    ["<leader><leader>"] = { ":vsplit<cr>", "splits vim pane vertically" },
    ["<leader>pi"] = { ":PackerSync<cr>", "installs plugins via Packer" },
    ["<leader>km"] = { ":Telescope keymaps<cr>", "shows current keymaps" },
  },
}

-- more keybinds!

return M
