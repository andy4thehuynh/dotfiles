-- kitty-adapter.lua
--
-- 
-- Allows seamless navigation between Neovim and Kitty.

return {
  'knubie/vim-kitty-navigator',
  lazy = false,
  build = "cp ./*.py ~/.config/kitty/"
}
