# .dotfiles

This repository uses the "Bare Git Repository" method to manage dotfiles. This approach avoids symlinks and keeps the home directory clean by using a separate git directory (`~/.cfg`) and setting the work tree to `$HOME`.

Inspired by the [Atlassian Dotfiles Tutorial](https://www.atlassian.com/git/tutorials/dotfiles).

## 🚀 Quick Start / Bootstrap

To set up these dotfiles on a new machine, run:

```bash
curl -L https://raw.githubusercontent.com/andy4thehuynh/dotfiles/master/bootstrap.sh | bash
```

This will:
1. Clone the repository as a bare repo to `~/.cfg`.
2. Checkout the files into your `$HOME`.
3. Add the `config` alias to your shell.
4. (macOS) Install Homebrew and packages from the `Brewfile`.
5. (macOS) Run system-level customizations.

## 🛠 Usage

Manage your dotfiles using the `config` command (an alias for `git` targeting the bare repo):

```bash
# Check status of dotfiles
config status

# Add a new dotfile
config add .zshrc
config commit -m "Update zshrc"
config push
```

## 💻 Hardware & System Context

This setup is optimized for:
- **macOS (Darwin):** MacBook Pro/Air with Apple Silicon.
  - **Window Manager:** [Aerospace](https://github.com/nikitabobko/AeroSpace) (i3-like tiling for macOS).
  - **Terminal:** [Kitty](https://sw.kovidgoyal.net/kitty/).
  - **Shell:** Zsh with [Mise](https://mise.jdx.dev/) for tool management.
- **Linux (Wayland):** 
  - **Compositor:** [Hyprland](https://hyprland.org/).
  - **Setup:** Configured via `.config/hypr`.

### 📱 Applications & Tools
- **Neovim:** [LazyVim](https://www.lazyvim.org/) based configuration.
- **Tmux:** Session management via `tmuxinator`.
- **VS Code:** Settings and keybindings sync.
- **Raycast:** (macOS) Custom extensions and AI integration.

## 🎨 Visuals & Fonts

This setup uses **Nerd Fonts** for icons.
1. Download a font (e.g., JetBrainsMono Nerd Font) from [Nerd Fonts](https://www.nerdfonts.com/font-downloads).
2. Install it on your system.
3. Configure your terminal (Kitty/iTerm2) to use it.

## 📦 Package Management
- **macOS:** Managed via `Brewfile`. Run `brew bundle` to install/update.
- **Python/Node/Ruby:** Managed via `mise`.

---
*Note: Ensure you have `git` installed before running the bootstrap script.*