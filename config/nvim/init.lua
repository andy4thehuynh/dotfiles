require("plugins")
require("globals")
require("options")
require("mappings")
require("lsp-configs")

require("andy4thehuynh.luasnip")
require("andy4thehuynh.lualine")
require("andy4thehuynh.nvim-tree")
require("andy4thehuynh.indent-blankline")
require("andy4thehuynh.telescope")
require("andy4thehuynh.noice")


local icons = require("nvim-nonicons")
icons.get("file")


require("nvim-web-devicons").setup({
	default = true
})


 -- git-blame.nvim
vim.g.gitblame_enabled = 0 -- git blame messages off
vim.g.gitblame_message_template = '<author> • <date> • <summary>'
vim.g.gitblame_date_format = '%r'
