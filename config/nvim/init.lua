require("plugins")
require("options")
require("mappings")
require("lsp-configs")
require("completion")

require("andy4thehuynh.nvim-tree")
require("andy4thehuynh.telescope")
require("andy4thehuynh.treesitter")
require("andy4thehuynh.indent-blankline")
require("andy4thehuynh.lualine")
require("andy4thehuynh.luasnip")
require("andy4thehuynh.noice")
require("andy4thehuynh.telekasten")
require("andy4thehuynh.neotest")

require("nvim-web-devicons").setup({
  default = true
})

local icons = require("nvim-nonicons")
icons.get("file")
