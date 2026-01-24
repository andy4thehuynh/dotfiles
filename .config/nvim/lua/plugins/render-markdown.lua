return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.icons", -- already installed via LazyVim
  },
  ft = { "markdown" },
  opts = {
    preset = "obsidian", -- mimics Obsidian UI styling
    render_modes = { "n", "c" }, -- render in normal and command mode, not insert
  },
}
