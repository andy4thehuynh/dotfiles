map <leader>b :!npm install<cr>

setlocal shiftwidth=2
setlocal tabstop=2

" For Solidity testing
map <Leader>t :call VimuxRunCommand("clear; traffic truffle test"."\n") <cr>
map <Leader>d :call VimuxRunCommand("clear; traffic truffle test --debug"."\n") <cr>
map <Leader>m :call VimuxRunCommand("clear; traffic truffle migrate"."\n") <cr>
map <Leader>c :call VimuxRunCommand("clear; traffic truffle compile"."\n") <cr>
