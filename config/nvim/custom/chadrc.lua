local M = {}

M.ui = {
  theme = 'chadracula',
  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
  },
  cmp = {
    style = 'atom_colored', -- default/flat_light/flat_dark/atom/atom_colored
  },
}

M.plugins = 'custom.plugins'
M.mappings = require "custom.remaps"

return M
