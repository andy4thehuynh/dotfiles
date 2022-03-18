setlocal shiftwidth=2
setlocal tabstop=2

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
