" For Solidity testing
map <Leader>st :call VimuxRunCommand("clear; traffic hh test"."\n") <cr>
map <Leader>sc :call VimuxRunCommand("clear; traffic hh compile"."\n") <cr>

" Build library package
map <Leader>b :call VimuxRunCommand("clear; npm run build"."\n") <cr>

" Console log from insert mode; Puts focus inside parentheses
imap cll console.log();<Esc><S-f>(a
" Console log from visual mode on next line, puts visual selection inside parentheses
vmap cll yocll<Esc>p
" Console log from normal mode, inserted on next line with word your on inside parentheses
nmap cll yiwocll<Esc><S-f>(a

" www plugin allows opening browser URLs from a Vim editor
" and devdocs is a fast and consistent documentation across languages
" source: https://github.com/waiting-for-dev/vim-www
" source: https://github.com/freeCodeCamp/devdocs
map <leader>d :Wopen https://devdocs.io/javascript/<cr>


" Rescan the entire buffer when highlighting
" source: https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim#highlighting-for-large-files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
