# Dotfiles

Personal dotfiles managed with a symlink-based bootstrap script. Clone the repo, run `bootstrap.sh`, and everything lands in the right place.

## Quick Start

```bash
git clone git@github.com:andy4thehuynh/dotfiles.git ~/Code/dotfiles
cd ~/Code/dotfiles
./bootstrap.sh
```

Use `--dry-run` to preview what it will do without making changes:

```bash
./bootstrap.sh --dry-run
```

## How It Works

Files in the repo use a `_` prefix instead of `.` so they're visible in the file tree. The bootstrap script strips the `_`, replaces it with `.`, and symlinks into place.

```
home/_zshrc         → ~/.zshrc
home/_gitconfig     → ~/.gitconfig
config/nvim/        → ~/.config/nvim
config/kitty/       → ~/.config/kitty
```

Existing files are backed up to `~/.dotfiles-backup/` before being replaced.

## Structure

```
home/           Files symlinked into $HOME (underscore prefix → dot prefix)
config/         Directories symlinked into $HOME/.config/
system/         Platform-specific setup scripts (run ad-hoc, not symlinked)
bootstrap.sh    Symlink manager with --dry-run support
Brewfile        Homebrew packages (macOS, run ad-hoc with brew bundle)
```

## Platform Support

- **macOS** — Primary. Apple Silicon, Aerospace, Kitty, Neovim/LazyVim.
- **Linux** — Secondary. Omakub on ThinkPad T480, Hyprland on Wayland. Bootstrap stub in place.

## What's Included

| Category | Tool | Config location |
|----------|------|----------------|
| Shell | Zsh | `home/_zshrc`, `home/_zshenv` |
| Editor | Neovim (LazyVim) | `config/nvim/` |
| Terminal | Kitty | `config/kitty/` |
| Multiplexer | Tmux + Tmuxinator | `home/_tmux.conf`, `config/tmuxinator/` |
| Window Manager | Aerospace (macOS) | `config/aerospace/` |
| Window Manager | Hyprland (Linux) | `config/hypr/` |
| Git | Git | `home/_gitconfig`, `home/_gitignore_global` |
| Editor | VS Code | `config/vscode/` |
| System Monitor | btop | `config/btop/` |
| Tool Manager | Mise | `config/mise/` |
| Theme | Catppuccin | Across kitty, btop, bat |

## Fonts

This setup uses Nerd Fonts for icons. Download from [nerdfonts.com](https://www.nerdfonts.com/font-downloads), install, and configure your terminal to use it.
