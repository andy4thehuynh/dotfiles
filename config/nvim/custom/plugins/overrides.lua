local M = {}

M.treesitter = {
  ensure_installed = {
    "astro",
    "c",
    "css",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "ruby",
    "toml",
    "vim",
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = false,
    icons = {
      show = {
        git = false,
      },
    },
  },
}

return M
