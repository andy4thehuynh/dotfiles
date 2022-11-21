require("plugins")
require("options")
require("mappings")
require("dap-configs")
require("lsp-configs")

require("andy4thehuynh.luasnip")
require("andy4thehuynh.lualine")
require("andy4thehuynh.nvim-tree")
require("andy4thehuynh.indent-blankline")
require("andy4thehuynh.telescope")
require("andy4thehuynh.noice")
require("andy4thehuynh.telekasten")


local icons = require("nvim-nonicons")
icons.get("file")


require("nvim-web-devicons").setup({
	default = true
})


 -- git-blame.nvim
vim.g.gitblame_enabled = 0 -- git blame messages off when opening a new buffer
vim.g.gitblame_message_template = '<author> • <date> • <summary>'
vim.g.gitblame_date_format = '%r'


require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "css",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "regex",
    "ruby",
    "scss",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml"
  },


  -- enables treesitter colorization
  highlight = { enable = true },


  -- enables code indentation
  indent = { enable = true },


  -- interprets html tags in set languages
  autotag = {
    enable = true,
    filetypes = {
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "xml",
    },
  },
})

require("bufferline").setup({
  options = {
    mode = "tabs",
    separator_style = "slant",
    max_name_length = 15,
    tab_size = 15,
    diagnostics = false,
    color_icons = true,
  }
})
