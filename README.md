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
home/_bashrc        → ~/.bashrc
home/_gitconfig     → ~/.gitconfig
config/nvim/        → ~/.config/nvim
config/kitty/       → ~/.config/kitty
config/zellij/      → ~/.config/zellij
```

Existing files are backed up to `~/.dotfiles-backup/` before being replaced.

### Special case: Starship

Starship reads its config from a **file** (`~/.config/starship.toml`), not a directory, so `bootstrap.sh` can't handle it automatically. After running bootstrap, symlink it manually:

```bash
ln -sf ~/Code/dotfiles/config/starship/starship.toml ~/.config/starship.toml
```

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
| Shell | Bash (primary, Homebrew) | `home/_bashrc`, `home/_bash_profile` |
| Shell | Zsh (backup) | `home/_zshrc`, `home/_zshenv` |
| Prompt | Starship (Catppuccin Mocha) | `config/starship/` |
| Editor | Neovim (LazyVim) | `config/nvim/` |
| Terminal | Kitty | `config/kitty/` |
| Multiplexer | Tmux + Tmuxinator | `home/_tmux.conf`, `config/tmuxinator/` |
| Multiplexer | Zellij (tmux-style bindings) | `config/zellij/` |
| Window Manager | Aerospace (macOS) | `config/aerospace/` |
| Window Manager | Hyprland (Linux) | `config/hypr/` |
| Git | Git | `home/_gitconfig`, `home/_gitignore_global` |
| Editor | VS Code | `config/vscode/` |
| System Monitor | btop | `config/btop/` |
| Tool Manager | Mise | `config/mise/` |
| Theme | Catppuccin | Across kitty, btop, bat, starship, zellij |

## Shells in parallel

Bash (Homebrew `/opt/homebrew/bin/bash`) is the primary login shell; Zsh is kept as a backup for any workflow that depends on it. `home/_bashrc` mirrors the original Zsh aliases, exports, and tool integrations (zoxide, fzf, mise, starship) and adds readline vi mode with cursor-shape NORMAL/INSERT indicators. Neither shell's config depends on the other; removing the Bash files leaves Zsh untouched.

## Zellij vs Tmux

Both multiplexers are installed. Zellij (`config/zellij/config.kdl`) uses a `Ctrl-a` prefix with splits (`|` / `-`), tab navigation (`h` / `l`), resize (`H/J/K/L`), and bare `Ctrl-h/j/k/l` for pane focus — matching the Tmux muscle memory in `home/_tmux.conf`.

Seamless Neovim ↔ Zellij pane navigation is wired through the [vim-zellij-navigator](https://github.com/hiasr/vim-zellij-navigator) WASM plugin (loaded from GitHub on first keypress) plus [zellij-nav.nvim](https://github.com/swaits/zellij-nav.nvim) on the Neovim side. While Zellij is in use, `config/nvim/lua/plugins/vim-tmux-navigator.lua` is disabled with `enabled = false`; flip it back if you return to Tmux.

## Fonts

This setup uses Nerd Fonts for icons. Download from [nerdfonts.com](https://www.nerdfonts.com/font-downloads), install, and configure your terminal to use it.
