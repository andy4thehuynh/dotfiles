map <leader>b :!npm install<cr>

setlocal shiftwidth=2
setlocal tabstop=2

" For Solidity testing
map <Leader>st :call VimuxRunCommand("clear; traffic hardhat test"."\n") <cr>
map <Leader>sc :call VimuxRunCommand("clear; traffic hardhat compile"."\n") <cr>
