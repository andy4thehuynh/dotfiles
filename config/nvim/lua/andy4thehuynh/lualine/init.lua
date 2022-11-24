require("lualine").setup({
	options = {
		theme = "dracula",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "" },
		lualine_c = { "filetype" },
		lualine_x = { "" },
		lualine_y = { "progress" },
		lualine_z = { "location" }
	},
})
