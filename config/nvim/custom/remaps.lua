local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["\\-"] = { ":split<cr>", "splits vim pane horizontally" },
    ["\\\\"] = { ":vsplit<cr>", "splits vim pane vertically" },
    ["<leader>km"] = { ":Telescope keymaps<cr>", "shows current keymaps" },
    ["<leader>g"] = { vim.cmd.Git, "opens fugitive git" },
  },
}

return M
