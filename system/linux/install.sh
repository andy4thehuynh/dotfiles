#!/bin/bash
# system/linux/install.sh — install packages not provided by Omakub
#
# Usage: ./system/linux/install.sh
#
# Idempotent: safe to re-run. Skips already-installed packages.
#
# Omakub already provides:
#   bat, btop, build-essential, curl, eza, fd-find, fzf, gh, git,
#   lazydocker, lazygit, mise, neovim, ripgrep, starship, tealdeer,
#   wl-clipboard, zellij, zoxide,
#   Nerd Fonts (CaskaydiaCove, Fira, JetBrains, Meslo)

set -e

echo "==> Installing packages not in Omakub..."

# Claude Code
if command -v claude &>/dev/null; then
  echo "  [skip] Claude Code already installed"
else
  echo "  [install] Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
fi

# Vivaldi
if command -v vivaldi &>/dev/null; then
  echo "  [skip] Vivaldi already installed"
else
  echo "  [install] Vivaldi"
  curl -fsSL https://repo.vivaldi.com/archive/linux_signing_key.pub \
    | sudo gpg --dearmor -o /usr/share/keyrings/vivaldi-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/vivaldi-archive-keyring.gpg] https://repo.vivaldi.com/archive/deb/ stable main" \
    | sudo tee /etc/apt/sources.list.d/vivaldi.list >/dev/null
  sudo apt-get update -qq
  sudo apt-get install -y vivaldi-stable
fi

echo ""
echo "==> Ensuring Go workspace directories..."
for dir in "$HOME/go/bin" "$HOME/go/pkg/mod" "$HOME/go/src"; do
  if [[ -d "$dir" ]]; then
    echo "  [skip] $dir exists"
  else
    echo "  [create] $dir"
    mkdir -p "$dir"
  fi
done

echo ""
echo "Done."
