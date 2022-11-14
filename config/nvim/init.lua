require("plugins")
require("options")
require("mappings")
require("completion")
require("lsp-configs")
require("andy4thehuynh.luasnip")


require("nvim-web-devicons").setup({
	default = true
})


local icons = require("nvim-nonicons")
icons.get("file")


require("nvim-tree").setup({
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
	},
})


require("lualine").setup({
	options = {
		theme = "dracula",
		icons_enabled = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "" },
		lualine_c = {
			{
				"filename",
				path = 1
			}
		},
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" }
	},
})
