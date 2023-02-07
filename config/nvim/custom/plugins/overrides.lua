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
    "astro-language-server",
    "css-lsp",
    "emmet-ls",
    "html-lsp",
    "tailwindcss-language-server",
    "typescript-language-server",
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
    indent_markers = {
      enable = true
    }
  },

  view = {
    mappings = {
      list = {
        { key = "s", action = "split" },
        { key = "i", action = "vsplit" },
        { key = "?", action = "toggle_help" },
      }
    }
  },
}

return M
