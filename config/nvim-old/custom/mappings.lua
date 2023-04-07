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
    ["<leader>db"] = { ":lua require'dap'.toggle_breakpoint()<cr>", "toggles debugger breakpoint" },
    ["<leader>dc"] = { ":lua require'dap'.continue()<cr>", "continue current debugger" },
    ["<leader>ds"] = { ":lua require'dap'.step_over()<cr>", "step over current debugger" },
    ["<leader>do"] = { ":lua require'dap'.repl.open()<cr>", "inspect debugger state via REPL" },
  },
}

-- more keybinds!

return M
