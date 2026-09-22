#!/usr/bin/env bash
# bootstrap/linux.sh — symlink dotfiles for Linux (ThinkPad T14, Omarchy).
# Usage: ./bootstrap/linux.sh [--dry-run]
#
# Omarchy manages: starship, mise, btop, bat, hypr DEFAULTS, themes.
# This script only links: home dotfiles, config/shared, and
# config/linux/hypr/*.lua override files (Omarchy loads them after defaults).
# Never overwrite Omarchy-managed files.

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
link_herdr

echo ""
echo "==> Symlinking Hyprland overrides (Omarchy 4.x loads these after defaults)"
mkdir -p "$HOME/.config/hypr"
for f in "$DOTFILES_DIR"/config/linux/hypr/*.lua; do
  backup_and_link "$f" "$HOME/.config/hypr/$(basename "$f")"
done

echo ""
echo "==> AUR packages (system/linux/pkglist.txt)"
PKGLIST="$DOTFILES_DIR/system/linux/pkglist.txt"
mapfile -t aur_pkgs < <(sed -E '/^[[:space:]]*#/d; s/[[:space:]]#.*//; /^[[:space:]]*$/d' "$PKGLIST")
if [[ "${#aur_pkgs[@]}" -eq 0 ]]; then
  echo "  [skip] system/linux/pkglist.txt is empty"
elif [[ "$DRY_RUN" == true ]]; then
  echo "  [dry-run] would install AUR: ${aur_pkgs[*]}"
else
  if ! omarchy pkg aur accessible &>/dev/null; then
    echo "  [skip] AUR unavailable — run later: omarchy pkg aur add ${aur_pkgs[*]}"
  elif omarchy pkg present "${aur_pkgs[@]}" &>/dev/null; then
    echo "  [skip] all AUR packages already present"
  else
    omarchy pkg aur add "${aur_pkgs[@]}"
  fi
fi

echo ""
echo "Bootstrap complete."
echo "Note: starship, mise, btop, bat, foot, hypr defaults are Omarchy-managed —"
echo "this repo intentionally does not touch them on Linux."
echo "Reload Hyprland to apply overrides: hyprctl reload && hyprctl configerrors"
