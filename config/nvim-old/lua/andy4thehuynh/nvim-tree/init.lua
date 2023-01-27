require("nvim-tree").setup({
  view = {
    mappings = {
      list = {
        { key = "s", action = "split" },
        { key = "i", action = "vsplit" },
        { key = "?", action = "toggle_help" },
      }
    }
  },
  renderer = {
    indent_markers = {
      enable = true
    }
  },
})

vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeToggle<cr>", {})
