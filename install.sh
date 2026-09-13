#!/usr/bin/env bash
# curl -fsSL https://raw.githubusercontent.com/andy4thehuynh/dotfiles/master/install.sh | bash

set -e

DOTFILES_REPO="https://github.com/andy4thehuynh/dotfiles.git"
DOTFILES_DIR="$HOME/src/dotfiles"

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  echo "==> Pulling latest dotfiles..."
  git -C "$DOTFILES_DIR" pull --ff-only
else
  echo "==> Cloning dotfiles..."
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

OS="$(uname)"

case "$OS" in
  Darwin)
    echo "==> Running macOS bootstrap..."
    bash "$DOTFILES_DIR/bootstrap/macos.sh" "$@"
    bash "$DOTFILES_DIR/system/macos/defaults.sh"
    ;;
  Linux)
    echo "==> Running Linux bootstrap..."
    bash "$DOTFILES_DIR/bootstrap/linux.sh" "$@"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac
