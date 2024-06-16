#!/bin/bash

DOTFILES_DIR="$HOME/code/dotfiles"


# Link individual files
ln -vsfn "$DOTFILES_DIR/git/_gitconfig" "$HOME/.gitconfig"
ln -vsfn "$DOTFILES_DIR/git/_gitignore_global" "$HOME/.gitignore_global"
ln -vsfn "$DOTFILES_DIR/config/zsh/_zshrc" "$HOME/.zshrc"
# ln -vsfn "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"

# Link folders
# ln -vsfn "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"