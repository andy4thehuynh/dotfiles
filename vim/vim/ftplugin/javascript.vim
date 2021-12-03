map <leader>b :!npm install<cr>

setlocal shiftwidth=2
setlocal tabstop=2

" For Solidity testing
map <Leader>st :call VimuxRunCommand("clear; traffic hardhat test"."\n") <cr>
map <Leader>sc :call VimuxRunCommand("clear; traffic hardhat compile"."\n") <cr>


" Console log from insert mode; Puts focus inside parentheses
imap cll console.log();<Esc><S-f>(a
" Console log from visual mode on next line, puts visual selection inside parentheses
vmap cll yocll<Esc>p
" Console log from normal mode, inserted on next line with word your on inside parentheses
nmap cll yiwocll<Esc><S-f>(a
