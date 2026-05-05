#!/bin/bash
# system/linux/theme-switcher.sh — sync zellij's default layout with the
# current omakub theme's lightness.
#
# Omakub's `omakub-sub/theme.sh` switches zellij's color theme but leaves the
# zjstatus plugin block in default.kdl untouched, so a light theme like
# rose-pine ends up with a dark mocha status bar. Run this after switching
# omakub themes to flip default.kdl between the dark and light variants.
# Existing zellij sessions need to be restarted to pick up the change.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Code/dotfiles}"
LAYOUTS_DIR="$DOTFILES_DIR/config/zellij/layouts"
ZELLIJ_CONFIG="$HOME/.config/zellij/config.kdl"

LIGHT_THEMES=(rose-pine)

current_theme="$(sed -n 's/^theme "\(.*\)"$/\1/p' "$ZELLIJ_CONFIG" | head -1)"

if [[ -z "$current_theme" ]]; then
  echo "theme-switcher: could not read theme from $ZELLIJ_CONFIG" >&2
  exit 1
fi

variant=dark
for t in "${LIGHT_THEMES[@]}"; do
  if [[ "$t" == "$current_theme" ]]; then
    variant=light
    break
  fi
done

target="default-${variant}.kdl"
ln -sfn "$target" "$LAYOUTS_DIR/default.kdl"

echo "zellij theme: $current_theme → default.kdl now points to $target"
echo "Restart any running zellij sessions to apply."
