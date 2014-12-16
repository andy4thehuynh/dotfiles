map <Leader>t :call Send_to_Tmux("clear; traffic bundle exec rspec ".expand("%")."\n") <cr>
map <leader>r :!ruby %<cr>
map <leader>b :!bundle<cr>

map <leader>em :Emodel<Space>
map <leader>ev :Eview<Space>
map <leader>ec :Econtroller<Space>
map <leader>ej :Ejavascript<Space>
map <leader>es :Espec<Space>

map <leader>rr :Rake<Space>routes

setlocal shiftwidth=2
setlocal tabstop=2
