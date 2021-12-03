map <Leader>t :call VimuxRunCommand("clear; traffic hardhat test"."\n") <cr>
map <Leader>c :call VimuxRunCommand("clear; traffic hardhat compile"."\n") <cr>

setlocal expandtab     " insert spaces when hitting TABs
setlocal shiftwidth=4
setlocal tabstop=4     " a hard TAB displays as 4 columns
setlocal textwidth=90
