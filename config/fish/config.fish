# Lets Fish know where to find asdf
source (echo "$HOME/.asdf")/asdf.fish

fish_add_path /usr/local/bin

set -gx EDITOR nvim
set -gx GIT_EDITOR nvim

alias vim=nvim
alias g=git
alias gs="git status"
alias gd="git diff"
alias gdc="git diff --cached"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit"
alias gca="git commit --amend"
alias gco="git checkout"
alias grh="git reset HEAD"

function fish_greeting
    # Do nothing
end

if status is-interactive
    starship init fish | source
end

