map <Leader>t :call VimuxRunCommand("clear; traffic hardhat test"."\n") <cr>
map <Leader>c :call VimuxRunCommand("clear; traffic hardhat compile"."\n") <cr>

setlocal expandtab     " insert spaces when hitting TABs
setlocal shiftwidth=4
setlocal tabstop=4     " a hard TAB displays as 4 columns
setlocal textwidth=90


" Console log from insert mode; Puts focus inside parentheses
imap cll console.log();<Esc><S-f>(a
" Console log from visual mode on next line, puts visual selection inside parentheses
vmap cll yocll<Esc>p
" Console log from normal mode, inserted on next line with word your on inside parentheses
nmap cll yiwocll<Esc><S-f>(a
