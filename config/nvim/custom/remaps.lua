local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["\\-"] = { ":split<cr>", "splits vim pane horizontally" },
    ["\\\\"] = { ":vsplit<cr>", "splits vim pane vertically" },
    ["<leader>km"] = { ":Telescope keymaps<cr>", "shows current keymaps" },
    ["<leader>g"] = { vim.cmd.Git, "opens fugitive git" },
    -- ["<leader>db"] = { ":lua require'dap'.toggle_breakpoint()<cr>", "toggles debugger breakpoint" },
    -- ["<leader>dc"] = { ":lua require'dap'.continue()<cr>", "continue current debugger" },
    -- ["<leader>ds"] = { ":lua require'dap'.step_over()<cr>", "step over current debugger" },
    -- ["<leader>do"] = { ":lua require'dap'.repl.open()<cr>", "inspect debugger state via REPL" },
  },
}

return M
