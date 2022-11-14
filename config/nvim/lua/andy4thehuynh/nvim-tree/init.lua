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


