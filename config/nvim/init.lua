require('options')
require('plugins')
require('mappings')

local icons = require("nvim-nonicons")
icons.get("file")

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

require('lualine').setup({
	options = {
		theme = 'dracula',
		icons_enabled = true,
	},
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
})

require('gitsigns').setup()

function kitty_run_command(command)
  -- kitty @ send-text --match "recent:1" hey there
  vim.cmd(":silent !kitty @ send-text -m 'recent:1' '" .. command .. "\\n'")
end

