# macOS Dotfiles Reorganization — Migration Guide

Handoff doc for the work MacBook. The dotfiles repo was reorganized on branch
`reorg/omarchy-quattro` of `git@github.com:andy4thehuynh/dotfiles.git`.
Goal: get the MacBook on the new tiered layout (shared / macos / linux),
matching the ThinkPad T14's terminal experience (Ghostty + LazyVim + tmux).

## TL;DR Changes

1. Repo location convention moved: dotfiles now expected at **`~/src/dotfiles`** (was `~/Code/dotfiles` on the Mac, `~/Dev` on Linux which became `~/src`).
2. `config/` split into **`config/shared/`**, **`config/macos/`**, **`config/linux/`**.
3. **Deleted**: zsh, zellij, kitty, vscode, cbsh, mac-mini home-server scripts, Omakub theme-switcher.
4. **Bootstrap system rewritten**: `bootstrap/symlink.sh` engine + `bootstrap/macos.sh` / `bootstrap/linux.sh` entry points (replacing `system/{macos,linux}/bootstrap.sh`).
5. starship, mise, btop, bat moved to `config/macos/` (Linux versions are Omarchy-managed).

## Steps on the MacBook

### 1. Snapshot current symlinks

```bash
ls -la ~ | grep "\->" > /tmp/old-links.txt
ls -la ~/.config | grep "\->" >> /tmp/old-links.txt
cat /tmp/old-links.txt
```

### 2. Move the repo

```bash
mkdir -p ~/src
mv ~/Code/dotfiles ~/src/dotfiles
cd ~/src/dotfiles
git fetch && git checkout reorg/omarchy-quattro   # or master once merged
```

Note: existing `~/.config/*` symlinks still point inside the repo — they now
resolve to `~/src/dotfiles/...` paths that shifted (e.g. `config/nvim` →
`config/shared/nvim`). Broken links will fail until step 4 relinks.

### 3. Pull latest changes

```bash
git pull --ff-only
```

### 4. Run the new macOS bootstrap

```bash
cd ~/src/dotfiles
./bootstrap/macos.sh --dry-run    # review what will change
./bootstrap/macos.sh              # apply
```

The bootstrap will:
- Symlink `home/_*` → `~/.*`
- Symlink `config/shared/*` → `~/.config/*`
- Symlink `config/macos/*` → `~/.config/*` (starship handled as **file** link: `~/.config/starship.toml` → `config/macos/starship/starship.toml`)
- Back up pre-existing files to `~/.dotfiles-backup/`
- Optionally run `brew bundle` from `system/macos/Brewfile`

### 5. Clean up symlinks deleted configs left behind

If you previously had zsh/zellij/kitty/vscode/cbsh symlinked, remove:

```bash
rm -f ~/.zshrc ~/.zshenv
rm -rf ~/.config/zellij ~/.config/kitty ~/.config/cbsh
# vscode lives at ~/Library/Application Support/Code/User — leave alone
```

Also remove stale **Starship manual symlink**: the bootstrap now handles it.

### 6. Verify

```bash
ls -la ~/.config | grep "\->"          # all targets under ~/src/dotfiles
nvim +checkhealth                       # LazyVim loads
tmux                                    # prefix Ctrl-a works
echo $SHELL                             # /opt/homebrew/bin/bash
ls ~/.config/starship.toml              # -> ~/src/dotfiles/config/macos/starship/starship.toml
ls ~/.config/mise/config.toml           # -> ~/src/dotfiles/config/macos/mise/config.toml
```

### 7. Optional: adopt `~/agents` workspace convention

```bash
mkdir -p ~/agents/{claude,omp,scratch}
```

Mirrors the T14 layout so agent workspaces are path-consistent across machines.

## Watch Outs

- **Brewfile**: review `system/macos/Brewfile` — may contain stale taps (zellij, kitty casks) worth pruning.
- **Aerospace & Ghostty** unchanged location-wise, but verify symlinks after step 4.
- **macOS shell drift**: `home/_bashrc` is shared with Linux now — macOS-specific bits (Homebrew PATH, etc.) live in the same file; confirm `eval "$(/opt/homebrew/bin/brew shellenv)"` path logic still gates on macOS only.
- **nvim obsidian.nvim** plugin kept — ensure vault paths in `config/shared/nvim/lua/plugins/obsidian.lua` are valid for the Mac.
- Old `system/macos/bootstrap.sh` and `system/macos/defaults.sh` remain valid for system-default tweaks but the **symlink logic moved** to `bootstrap/macos.sh`.
