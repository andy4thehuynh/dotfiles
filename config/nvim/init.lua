-- Check if we're in VSCode context
if vim.g.vscode then
  vim.schedule(function() -- delay print so it appears after UI is ready
    print("✅ VSCode Neovim integration loaded!")
  end)
else
  -- bootstrap lazy.nvim, LazyVim and your plugins
  require("config.lazy")
  print('Neovim loaded!')
end