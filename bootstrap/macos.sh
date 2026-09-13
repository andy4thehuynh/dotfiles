#!/usr/bin/env bash
# bootstrap/macos.sh — symlink dotfiles for macOS (work MacBook).
# Usage: ./bootstrap/macos.sh [--dry-run]

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "[DRY RUN] No changes will be made."
  echo ""
fi

source "$DOTFILES_DIR/bootstrap/symlink.sh"

link_home

echo ""
echo "==> Symlinking shared configs (both hosts)"
link_config_dir "$DOTFILES_DIR/config/shared"

echo ""
echo "==> Symlinking macOS configs"
link_config_dir "$DOTFILES_DIR/config/macos"

# Starship expects ~/.config/starship.toml (a file), not a directory.
backup_and_link "$DOTFILES_DIR/config/macos/starship/starship.toml" "$HOME/.config/starship.toml"

echo ""
echo "==> Optional: brew bundle (system/macos/Brewfile)"
if command -v brew &>/dev/null; then
  if [[ "$DRY_RUN" == false ]]; then
    read -rp "Run brew bundle now? [y/N] " ans
    [[ "$ans" == [yY] ]] && brew bundle --file="$DOTFILES_DIR/system/macos/Brewfile"
  else
    echo "  [dry-run] would prompt to run: brew bundle"
  fi
else
  echo "  brew not found; install Homebrew first."
fi

echo ""
echo "Bootstrap complete. Restart your shell or run: source ~/.bashrc"
