local set = vim.api.nvim_set_option

vim.o.termguicolors = true -- expands usable colors, if terminal supports it
vim.cmd[[colorscheme dracula]] -- sets Neovim theme color

-- nvim-cmp documentation suggests setting completopt with these values
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }


--
-- Basic Options
--
set("swapfile", false) -- disable creation of Vim .swp files
set("clipboard", "unnamedplus") -- enables clipboard between nvim and other programs
set("expandtab", true) -- tabs into spaces
set("shiftwidth", 2) -- number of spaces when indenting the text
set("tabstop", 2) -- number of spaces for tabs
set("relativenumber", true) -- shows lines numbers heliocentric from current one
set("number", true) -- shows the line numbers
set("smartcase", true) -- case-insensitive if you only use lowercase letters;
set("ignorecase", true) -- all searches will be case insensitive
set("showcmd", true) -- shows partial commands in the last line of the screen
set("showmode", true) -- insert, replace or visual mode put on last line as a message
set("hidden", true) -- hide unused buffers
set("wildmenu", true) -- shows a more advanced menu for autocomplete suggestions
set("wildmode", "list:longest") -- displays completion mode
set("hlsearch", true) -- highlights search patterns
set("wrap", true) -- ensures text visibility stays within the window
set("scrolloff", 10) --  minimal number of screen lines to keep above and below the cursor
set("ruler", true) -- shows cursor position in a file
set("title", true) -- shows the title of the file
set("backup", false) -- disables creation of backup files
set("writebackup", false) -- disable backup writes of a current file
set("laststatus", 2) -- displays the status line, always
set("shell", "/bin/zsh") -- sets shell for Vim

-- automatic syntax detection support for open files
vim.cmd([[
  filetype plugin indent on
  syntax on
]])
