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


require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    hover = {
      enabled = false
    }
  },


  -- you can enable a preset for easier configuration
  presets = {
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },


  -- Hides written messages (on save events)
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
  },
})


 -- git-blame.nvim
vim.g.gitblame_enabled = 0 -- git blame messages off
vim.g.gitblame_message_template = '<author> • <date> • <summary>'
vim.g.gitblame_date_format = '%r'
