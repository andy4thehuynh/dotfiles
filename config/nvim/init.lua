require 'plugins'
require 'mappings'

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- -- empty setup using defaults
require("nvim-web-devicons").setup({
  default = true
})

require('nvim-tree').setup {
  view = {
    mappings = {
      list = {
        { key = "<C-e>", action = "" },
        { key = "s", action = "split" },
        { key = "i", action = "vsplit" },
        { key = "I", action = "toggle_dotfiles" },
        { key = "?", action = "toggle_help" },
      }
    }
  },
  renderer = {
    indent_markers = {
      enable = true
    }
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false
      },
    }
  },
}




-- " remaps escape key to be more ergonomically convenient
-- tnoremap <Esc> <C-\><C-n>
-- tnoremap <A-[> <Esc>]

-- " switching between split windows for terminal mode
-- tnoremap <A-h> <c-\><c-n><c-w>h
-- tnoremap <A-j> <c-\><c-n><c-w>j
-- tnoremap <A-k> <c-\><c-n><c-w>k
-- tnoremap <A-l> <c-\><c-n><c-w>l
-- " switching between split windows for normal mode
-- nnoremap <A-h> <c-w>h
-- nnoremap <A-j> <c-w>j
-- nnoremap <A-k> <c-w>k
-- nnoremap <A-l> <c-w>l



-- call plug#begin('~/config/nvim/plugged')
-- " The default plugin directory will be as follows:
-- "   - Vim (Linux/macOS): '~/.vim/plugged'
-- "   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
-- " You can specify a custom plugin directory by passing it as the argument
-- "   - e.g. `call plug#begin('~/.vim/plugged')`

-- " Initialize plugin system
-- " - Automatically executes `filetype plugin indent on` and `syntax enable`.
-- Plug 'Mofiqul/dracula.nvim'
-- Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
-- Plug 'nvim-tree/nvim-tree.lua'"

-- call plug#end()

