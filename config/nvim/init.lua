require("plugins")
require("options")
require("mappings")
require("lsp-configs")

require("andy4thehuynh.luasnip")
require("andy4thehuynh.lualine")
require("andy4thehuynh.nvim-tree")
require("andy4thehuynh.indent-blankline")


local icons = require("nvim-nonicons")
icons.get("file")


require("nvim-web-devicons").setup({
	default = true
})
