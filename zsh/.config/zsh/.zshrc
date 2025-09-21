
##########################################################
#
# oh-my-zsh configuration
#
##########################################################

# Checks for secure environment secrets file and sources it only if it exists
[ -f ~/.env_secrets ] && source ~/.env_secrets

# Configures Go with zsh
export GOPATH=$HOME/Code/go

# If you come from bash you might have to change your $PATH.
# Must include Bob in path to manage Neovim versions
export PATH=$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$GOPATH/bin:$HOME/.local/share/bob/nvim-bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.config/zsh/.oh-my-zsh"

# Set folder for config
export ZSH_CUSTOM="$HOME/.config/zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

# Optional: Enable plugins
# source "${HOME}/.oh-my-zsh/custom/plugins/colored-man-pages/colored-man-pages.plugin.zsh"

source $ZSH/oh-my-zsh.sh

##########################################################
#
# User configuration
#
##########################################################

# # Check the system architecture
# if [[ "$(uname -m)" == "x86_64" ]]; then
#   # Configuration for x86_64 architecture
#   echo "Running on x86_64 architecture"
#   # Add your x86_64 specific configurations here
# else
#   # Configuration for arm64 architecture (M1 MacBooks)
#   echo "Running on ARM (M1) architecture"
#   # Add your M1 specific configurations here
# fi

export EDITOR='nvim'

# Configures Tmuxinator path
export TMUXINATOR_CONFIG=~/.config/tmuxinator
alias -g tm='tmuxinator'

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
alias -g g='git'
alias -g ga='git add'
alias -g gaa='git add -A'
alias -g gc='git commit --verbose'
alias -g gca='git commit --amend'
alias -g gs='git status'
alias -g gss='git status -s'
alias -g gco='git checkout'
alias -g gcob='git checkout -b'
alias -g gd='git diff'
alias -g gdc='git diff --cached'
alias -g grh='git reset HEAD'
alias -g gdh='git diff origin/master..HEAD'  # review changes from the master branch in Github

alias -g rl="source ${HOME}/.config/zsh/.zshrc"
alias -g cdd="cd ${HOME}/.dotfiles"
alias -g n='nvim'
alias -g fabric='fabric-ai'

alias nb='NVIM_APPNAME="nvim.bak" nvim'

# opens man page with nvim for syntax highlight & vim motions support
export MANPAGER='nvim +Man!'

# Configures Cargo package manager (Rust)
if [ -e "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
else
  echo "Must download Rust from official website"
fi

# --- Eza (better ls) ---
alias ls="eza --icons=always"

# --- Zoxide (better cd) ---
eval "$(zoxide init zsh)"
alias cd="z"

# --- fzf (better fuzzy finder) ---
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# - Use fd instead of fzf
export FZF_DEFAULT_COMMAND="fd —hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd —-type=d -hidden -strip-cwd-prefix --exclude .git"
# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# Hooks mise (runtime manager)
# https://mise.jdx.dev/dev-tools/shims.html#zshrc-bashrc-files
eval "$(~/.local/bin/mise activate zsh)"

# Configures Go with zsh
export GOPATH=$HOME/Code/go
eval "$(~/.local/bin/mise hook-env -s zsh)"
