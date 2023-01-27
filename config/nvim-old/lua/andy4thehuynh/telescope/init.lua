require("telescope").setup{
  defaults = {
    file_ignore_patterns =
      {
        "node_modules",
        "vendor",
      },
  },
  pickers = {
    find_files = { theme = "dropdown" },
    live_grep = { theme = "dropdown" }
  },
  extensions = {
    media_files = {
      -- filetypes whitelist
      -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
      filetypes = {"png", "webp", "jpg", "jpeg"},
      find_cmd = "rg" -- find command (defaults to `fd`)
    }
  }
}
vim.api.nvim_set_keymap("n", "<C-P>", ":Telescope find_files<cr>", {})
vim.api.nvim_set_keymap("n", "<C-/>", ":Telescope live_grep<cr>", {})
vim.api.nvim_set_keymap("n", "<C-;>", ":Telescope help_tags<cr>", {})
