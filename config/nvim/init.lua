require('options')
require('plugins')
require('mappings')
require('lsp-configs')

local icons = require("nvim-nonicons")
icons.get("file")

require('nvim-tree').setup {
  view = {
    mappings = {
      list = {
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
  }
}

require('lualine').setup({
	options = {
		theme = 'dracula',
		icons_enabled = true,
	},
  sections = {
    lualine_a = {'mode'},
    lualine_b = {''},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
})

require('gitsigns').setup()
require("nvim-autopairs").setup {}

function kitty_run_command(command)
  -- kitty @ send-text --match "recent:1" hey there
  vim.cmd(":silent !kitty @ send-text -m 'recent:1' '" .. command .. "\\n'")
end

