require 'plugins'
require 'mappings'
require 'line-number'

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd[[colorscheme dracula]]

require("nvim-web-devicons").setup({
  default = true
})

require('nvim-tree').setup {
  view = {
    mappings = {
      list = {
        { key = "<C-e>", action = "" },
        { key = "s", action = "split" },
        { key = "i", action = "vsplit" },
        { key = "?", action = "toggle_help" },
      }
    }
  },
  renderer = {
    indent_markers = {
      enable = true
    }
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false
      },
    }
  },
}

function kitty_run_command(command)
  -- kitty @ send-text --match "recent:1" hey there
  vim.cmd(":silent !kitty @ send-text -m 'recent:1' '" .. command .. "\\n'")
end
