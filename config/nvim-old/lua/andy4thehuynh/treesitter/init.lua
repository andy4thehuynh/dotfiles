require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "css",
    "html", "javascript", "json",
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

  -- treesitter colorization
  highlight = { enable = true },

  -- code indentation
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

  -- completes ruby do/end blocks
  endwise = {
    enable = true,
  },


  -- nvim-ts-rainbow
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  }
})
