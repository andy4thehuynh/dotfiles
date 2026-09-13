# Dotfiles

Personal dotfiles for macOS (work MacBook) and Linux (ThinkPad T14, Omarchy). Symlink-based, with per-host config tiers.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/andy4thehuynh/dotfiles/master/install.sh | bash
```

Detects OS and runs the appropriate bootstrap. Manual:

```bash
git clone git@github.com:andy4thehuynh/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
./bootstrap/macos.sh        # or ./bootstrap/linux.sh
./bootstrap/macos.sh --dry-run   # preview without changes
```

Existing files are backed up to `~/.dotfiles-backup/` before being replaced.

## Structure

```
home/                Files symlinked into $HOME (both hosts; `_` prefix → `.`)
config/shared/       Symlinked into ~/.config/ on both hosts
config/macos/        Symlinked on macOS only
config/linux/        Symlinked on Linux only
bootstrap/           Symlink engine + per-OS entry points
system/              Ad-hoc platform scripts (not symlinked)
install.sh           OS-detecting dispatcher
```

## Platform Split

Some configs are **Omarchy-managed on Linux** and must NOT be forced into place there — Omarchy rewrites them on `omarchy theme set`, update, and refresh. Keep them macOS-only:

| Tool      | macOS (this repo)              | Linux (Omarchy manages)                    |
|-----------|--------------------------------|--------------------------------------------|
| starship  | `config/macos/starship/`       | `~/.config/starship.toml` (Omarchy theme)  |
| mise      | `config/macos/mise/`           | `~/.config/mise/config.toml`               |
| btop      | `config/macos/btop/`           | `~/.config/btop/` (Omarchy theme)          |
| bat       | `config/macos/bat/`            | `~/.config/bat/` (Omarchy theme)           |
| hypr      | n/a                            | `config/linux/hypr/*.lua` (overrides only) |
| aerospace | `config/macos/aerospace/`      | n/a                                        |
| ghostty   | `config/macos/ghostty/`        | n/a (Omarchy uses foot/alacritty)          |

**Hypr on Omarchy 4:** configs are Lua (`hyprland.lua` → `monitors.lua`, `input.lua`, `bindings.lua`). Omarchy loads its defaults first, then these user files — so `config/linux/hypr/` contains **overrides only**, never full configs. Validate with `hyprctl reload && hyprctl configerrors`.

Truly shared (identical on both hosts): `nvim`, `tmuxinator`, plus everything in `home/`.

## What's Included

| Category     | Tool             | Location                              |
|--------------|------------------|---------------------------------------|
| Shell        | Bash             | `home/_bashrc`, `home/_bash_profile`  |
| Editor       | Neovim (LazyVim) | `config/shared/nvim/`                 |
| Multiplexer  | Tmux             | `home/_tmux.conf`                     |
| Mux layouts  | Tmuxinator       | `config/shared/tmuxinator/`           |
| WM (macOS)   | Aerospace        | `config/macos/aerospace/`             |
| WM (Linux)   | Hyprland         | `config/linux/hypr/`                  |
| Terminal     | Ghostty          | `config/macos/ghostty/`               |
| Prompt       | Starship         | `config/macos/starship/` (macOS only) |
| Tools        | Mise             | `config/macos/mise/` (macOS only)     |
| Git          | Git              | `home/_gitconfig`, `_gitignore_global`|

## Conventions

- Bash is the login shell on both hosts; `_bashrc` wires zoxide, fzf, mise, starship, readline vi mode with NORMAL/INSERT cursor shapes.
- Neovim ↔ Tmux seamless navigation via `Christoomey/vim-tmux-navigator` (plugin) + `home/_tmux.conf` (pane tty inspection). `Ctrl-h/j/k/l` crosses nvim splits into tmux panes. Identical on both hosts — this is the core of the cross-platform terminal experience.
- Tmux prefix is `Ctrl-a`; see `home/_tmux.conf` for splits/tab bindings.

## Fonts

Font is **JetBrainsMono Nerd Font** on both hosts.

- Linux (Omarchy): preinstalled.
- macOS: `brew install --cask font-jetbrains-mono-nerd-font`
