#!/bin/bash

DOTFILES_DIR="$HOME/code/dotfiles"

ln -vsfn "$DOTFILES_DIR/config/fish" "$HOME/.config/fish"
ln -vsfn "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"

ln -vsfn "$DOTFILES_DIR/git/_gitconfig" "$HOME/.gitconfig"
ln -vsfn "$DOTFILES_DIR/git/_gitignore_global" "$HOME/.gitignore_global"
ln -vsfn "$DOTFILES_DIR/config/asdf/_tool-versions" "$HOME/.tool-versions"
ln -vsfn "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"
