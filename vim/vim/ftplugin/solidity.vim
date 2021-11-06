map <Leader>t :call VimuxRunCommand("clear; traffic truffle test"."\n") <cr>
map <Leader>d :call VimuxRunCommand("clear; traffic truffle test --debug"."\n") <cr>
map <Leader>m :call VimuxRunCommand("clear; traffic truffle migrate"."\n") <cr>
map <Leader>c :call VimuxRunCommand("clear; traffic truffle compile"."\n") <cr>

setlocal expandtab     " insert spaces when hitting TABs
setlocal shiftwidth=4
setlocal tabstop=4     " a hard TAB displays as 4 columns
setlocal textwidth=90
