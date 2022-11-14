require("plugins")
require("options")
require("mappings")
require("lsp-configs")

require("andy4thehuynh.luasnip")
require("andy4thehuynh.lualine")
require("andy4thehuynh.nvim-tree")
require("andy4thehuynh.indent-blankline")
require("andy4thehuynh.telescope")


local icons = require("nvim-nonicons")
icons.get("file")


require("nvim-web-devicons").setup({
	default = true
})

require('bufferline').setup({
      -- Enable/disable close button
  closable = true,
    -- Sets the maximum buffer name length.
  maximum_length = 20,
})
