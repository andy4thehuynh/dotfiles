#!/usr/bin/env bash
# bootstrap/symlink.sh — shared symlink engine. Sourced by macos.sh / linux.sh,
# not invoked directly.
#
# Expects: DOTFILES_DIR, DRY_RUN; provides: backup_and_link, link_home,
# link_config_dir (directory symlinks), link_config_files (file symlinks).

BACKUP_DIR="$HOME/.dotfiles-backup"

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

# home/_foo → ~/.foo
link_home() {
  echo "==> Symlinking home dotfiles"
  local file filename
  for file in "$DOTFILES_DIR"/home/_*; do
    filename="$(basename "$file")"
    backup_and_link "$file" "$HOME/.${filename#_}"
  done
}

# Symlink each top-level dir/file under $1 into ~/.config/
link_config_dir() {
  local src_root="$1"
  [[ -d "$src_root" ]] || return 0
  local item name
  mkdir -p "$HOME/.config"
  for item in "$src_root"/*; do
    name="$(basename "$item")"
    # herdr needs config.toml linked per-file; its dir holds runtime sockets/logs
    [[ "$name" == "herdr" ]] && continue
    backup_and_link "$item" "$HOME/.config/$name"
  done
}

# ~/.config/herdr must stay a real dir (runtime sockets/logs); link only config.toml
link_herdr() {
  mkdir -p "$HOME/.config/herdr"
  backup_and_link "$DOTFILES_DIR/config/shared/herdr/config.toml" "$HOME/.config/herdr/config.toml"
}
