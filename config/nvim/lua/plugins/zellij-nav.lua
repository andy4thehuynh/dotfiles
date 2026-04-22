-- Neovim side of seamless Zellij pane navigation.
-- Pairs with the hiasr/vim-zellij-navigator WASM plugin configured in
-- config/zellij/config.kdl — that plugin intercepts Ctrl-h/j/k/l at the Zellij
-- layer, detects whether the focused pane is running Neovim (via
-- `zellij list-clients`), and forwards the keys into Neovim when it is.
-- This plugin then handles the nvim-internal side: move across nvim splits,
-- and fall through to `zellij action move-focus[-or-tab]` at split edges.

return {
  "swaits/zellij-nav.nvim",
  lazy = true,
  event = "VeryLazy",
  keys = {
    { "<c-h>", "<cmd>ZellijNavigateLeft<cr>",  { silent = true, desc = "navigate left" } },
    { "<c-j>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "navigate down" } },
    { "<c-k>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "navigate up" } },
    { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
  },
  opts = {},
}
