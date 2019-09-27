map <Leader>t :call VimuxRunCommand("clear; traffic bundle exec rspec ".expand("%")."\n") <cr>
map <leader>r :!ruby %<cr>
map <leader>b :!bundle<cr>
map <Leader>l :call VimuxRunCommand("clear; bundle exec rspec  ".expand("%").":".line(".")."\n") <cr>
map <Leader>L :call VimuxRunCommand("clear; traffic bundle exec rspec  ".expand("%").":".line(".")."\n") <cr>

map <leader>em :Emodel<Space>
map <leader>ev :Eview<Space>
map <leader>ec :Econtroller<Space>
map <leader>ej :Ejavascript<Space>
map <leader>es :Espec<Space>

map <leader>rr :Rake<Space>routes

setlocal shiftwidth=2
setlocal tabstop=2
