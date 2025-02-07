#!/bin/bash

DOTFILES_DIR="$HOME/Code/dotfiles"

# Links files
ln -vsfn "$DOTFILES_DIR/git/_gitconfig" "$HOME/.gitconfig"
ln -vsfn "$DOTFILES_DIR/git/_gitignore_global" "$HOME/.gitignore_global"
ln -vsfn "$DOTFILES_DIR/config/mise/config.toml" "$HOME/.config/mise/config.toml"
ln -vsfn "$DOTFILES_DIR/config/zsh/_zshrc" "$HOME/.zshrc"

# Links folders
ln -vsfn "$DOTFILES_DIR/config/alacritty" "$HOME/.config/alacritty"
ln -vsfn "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"