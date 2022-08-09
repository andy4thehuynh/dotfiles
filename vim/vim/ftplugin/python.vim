setlocal textwidth=90
setlocal shiftwidth=4
setlocal tabstop=4
setlocal expandtab
setlocal softtabstop=4
setlocal fileformat=unix
setlocal autoindent

map <Leader>t :call VimuxRunCommand("clear; py.test ".expand("%")."\n") <cr>
