#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup"
DRY_RUN=false

if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "[DRY RUN] No changes will be made."
  echo ""
fi

backup_and_link() {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$src" ]]; then
      echo "  [skip] $dest already linked"
      return
    fi

    echo "  [backup] $dest → $BACKUP_DIR/"
    if [[ "$DRY_RUN" == false ]]; then
      mkdir -p "$BACKUP_DIR/$(dirname "${dest#$HOME/}")"
      mv "$dest" "$BACKUP_DIR/${dest#$HOME/}"
    fi
  fi

  echo "  [link] $src → $dest"
  if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
  fi
}

OS="$(uname)"

# --- Home dotfiles ---

echo "==> Symlinking home dotfiles"
for file in "$DOTFILES_DIR"/home/_*; do
  filename="$(basename "$file")"
  dotname=".${filename#_}"
  backup_and_link "$file" "$HOME/$dotname"
done

# --- XDG config directories ---

echo ""
echo "==> Symlinking config directories"
mkdir -p "$HOME/.config"
for dir in "$DOTFILES_DIR"/config/*/; do
  dirname="$(basename "$dir")"
  backup_and_link "$dir" "$HOME/.config/$dirname"
done

# --- Platform-specific symlinks ---

if [[ "$OS" == "Darwin" ]]; then
  VSCODE_DEST="$HOME/Library/Application Support/Code/User"
  VSCODE_SRC="$DOTFILES_DIR/config/vscode"
  if [[ -d "$VSCODE_SRC" ]]; then
    echo ""
    echo "==> Symlinking VSCode settings (macOS)"
    mkdir -p "$VSCODE_DEST"
    for file in settings.json keybindings.json tasks.json; do
      if [[ -f "$VSCODE_SRC/$file" ]]; then
        backup_and_link "$VSCODE_SRC/$file" "$VSCODE_DEST/$file"
      fi
    done
  fi
elif [[ "$OS" == "Linux" ]]; then
  echo ""
  echo "==> Linux symlinks coming soon (Omakub)"
fi

echo ""
echo "Bootstrap complete!"
