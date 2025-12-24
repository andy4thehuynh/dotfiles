-- Detect platform once
local is_macos = vim.fn.has("macunix") == 1

-- Load shared config first
require("config.options")
require("config.keymaps")

if is_macos then
  require("platform.macos")
else
  require("platform.linux")
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
