#!/bin/bash

DOT_DIR="$HOME/Code/dotfiles"

# Links files
ln -vsfn "$DOT_DIR/git/_gitconfig" "$HOME/.gitconfig"
ln -vsfn "$DOT_DIR/git/_gitignore_global" "$HOME/.gitignore_global"
ln -vsfn "$DOT_DIR/config/mise/config.toml" "$HOME/.config/mise/config.toml"
ln -vsfn "$DOT_DIR/config/zsh/_zshrc" "$HOME/.zshrc"

# Links folders
ln -vsfn "$DOT_DIR/config/nvim" "$HOME/.config/nvim"
ln -vsfn "$DOT_DIR/config/nvim.bak" "$HOME/.config/nvim.bak"
