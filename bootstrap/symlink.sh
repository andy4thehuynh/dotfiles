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
# omp (oh-my-pi) agent config. ~/.omp is runtime-owned, so link only config.yml.
link_omp() {
  local omp_dir="$HOME/.omp/agent"
  [[ -d "$omp_dir" ]] || mkdir -p "$omp_dir"
  backup_and_link "$DOTFILES_DIR/config/ai/omp/config.yml" "$omp_dir/config.yml"
}

# Claude Code AI configuration (ai-config repo).
# Symlinks skills, rules, agents, output styles into ~/.claude/.
link_claude() {
  local claude_dir="$HOME/.claude"
  local ai_dir="$DOTFILES_DIR/config/ai"

  [[ -d "$ai_dir" ]] || return 0

  echo "==> Setting up Claude Code configuration"
  mkdir -p "$claude_dir/output-styles"
  mkdir -p "$claude_dir/skills"
  mkdir -p "$claude_dir/agents"

  # CLAUDE.md — repo-scoped conventions
  backup_and_link "$ai_dir/claude-code.md" "$claude_dir/CLAUDE.md"

  # Output style
  backup_and_link "$ai_dir/core.md" "$claude_dir/output-styles/prime.md"

  # statusline.sh
  backup_and_link "$ai_dir/statusline.sh" "$claude_dir/statusline.sh"

  # Skills — globbed directories
  for skill in "$ai_dir"/skills/*/; do
    [[ -d "$skill" ]] || continue
    local skill_name
    skill_name="$(basename "$skill")"
    backup_and_link "$skill" "$claude_dir/skills/$skill_name"
  done

  # Work skills (demo-*, sfdc-extract, couchbase-mcp) — macOS work
  # profile only. The personal Linux machine keeps a lean skill set.
  if [[ "$(uname)" == "Darwin" ]]; then
    for skill in "$ai_dir"/work-skills/*/; do
      [[ -d "$skill" ]] || continue
      local work_skill_name
      work_skill_name="$(basename "$skill")"
      backup_and_link "$skill" "$claude_dir/skills/$work_skill_name"
    done
  fi

  # Agents — .md files
  for agent in "$ai_dir"/agents/*.md; do
    [[ -f "$agent" ]] || continue
    local agent_name
    agent_name="$(basename "$agent")"
    backup_and_link "$agent" "$claude_dir/agents/$agent_name"
  done

  # Rules — .md files
  for rule in "$ai_dir"/rules/*.md; do
    [[ -f "$rule" ]] || continue
    local rule_name
    rule_name="$(basename "$rule")"
    backup_and_link "$rule" "$claude_dir/rules/$rule_name"
  done
  # settings.json — link on macOS (work), skip on Linux (personal keeps own)
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "  [link] settings.json (macOS — Couchbase MCPs, work plugins)"
    backup_and_link "$ai_dir/settings.json" "$claude_dir/settings.json"
  fi

  # ~/cbme/CLAUDE.md — work context, macOS only
  if [[ "$(uname)" == "Darwin" ]]; then
    backup_and_link "$ai_dir/work.md" "$HOME/cbme/CLAUDE.md"
  fi

  echo ""
  echo "Claude Code configuration linked."
  echo "  → ~/.claude/ contains skills, rules, agents, settings.json"
}
