require("lualine").setup({
	options = {
		theme = "dracula",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "" },
		lualine_c = { "filename" },
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" }
	},
})
