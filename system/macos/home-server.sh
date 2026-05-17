#!/bin/bash
# home-server.sh — provisions a Mac Mini as a headless home server.
#
# Idempotent: every step checks state before changing it. Safe to re-run.
#
# What this configures:
#   - Hostname (HostName, LocalHostName, ComputerName)
#   - Power management (pmset): never sleep, auto-restart, wake-on-LAN
#   - Screen saver disabled, display sleep at 10 min
#   - SSH / Remote Login enabled
#   - Application Firewall on, stealth mode on
#   - Software updates: security/data only (no unattended OS upgrades)
#   - Homebrew (installed if missing)
#   - OrbStack (container runtime, lighter than Docker Desktop)
#   - Ollama with a LaunchAgent binding 0.0.0.0:11434 for Tailscale clients
#
# Manual steps still required (printed at the end):
#   - Enable auto-login in System Settings (FileVault must be off for true
#     auto-login)
#   - Authenticate Tailscale on this device
#   - Run OrbStack.app once to complete first-run setup
#   - Restrict who can reach Ollama via Tailscale ACLs (port 11434)
#   - Grant Full Disk Access to Terminal/iTerm if pmset/systemsetup steps
#     report permission errors
#
# Usage:
#   ./home-server.sh                  # apply
#   ./home-server.sh --dry-run        # preview without changing anything
#   HOSTNAME_NEW=mini ./home-server.sh
#
# OrbStack note:
#   Closed-source proprietary software by Orbital Labs (small team, active
#   since 2022). Signed and notarized; free for personal use. Trade-off vs.
#   Docker Desktop: dramatically lower RAM and faster on Apple Silicon, but
#   not open source.

set -euo pipefail

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

HOSTNAME_NEW="${HOSTNAME_NEW:-mini}"

# ---------- helpers ----------

step() { printf '\n==> %s\n' "$*"; }
ok()   { printf '  [ok] %s\n' "$*"; }
skip() { printf '  [skip] %s\n' "$*"; }
chg()  { printf '  [change] %s\n' "$*"; }
warn() { printf '  [warn] %s\n' "$*"; }

run() {
  if [[ "$DRY_RUN" == true ]]; then
    printf '  [dry-run] %s\n' "$*"
  else
    eval "$@"
  fi
}

# ---------- preflight ----------

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script is for macOS only." >&2
  exit 1
fi

if [[ "$DRY_RUN" == true ]]; then
  echo "[DRY RUN] No changes will be made."
fi

# Prime sudo once so subsequent calls don't prompt mid-script.
if [[ "$DRY_RUN" == false ]]; then
  sudo -v
fi

# ---------- hostname ----------

step "Hostname"
current_hostname="$(scutil --get HostName 2>/dev/null || true)"
if [[ "$current_hostname" == "$HOSTNAME_NEW" ]]; then
  skip "HostName already $HOSTNAME_NEW"
else
  chg "HostName/LocalHostName/ComputerName -> $HOSTNAME_NEW"
  run "sudo scutil --set HostName \"$HOSTNAME_NEW\""
  run "sudo scutil --set LocalHostName \"$HOSTNAME_NEW\""
  run "sudo scutil --set ComputerName \"$HOSTNAME_NEW\""
fi

# ---------- power management ----------

step "Power management (pmset)"
# sleep=0 keeps the system awake; displaysleep=10 still lets the display
# sleep; autorestart=1 boots back up after power loss; powernap=0 prevents
# unexpected wakes; womp=1 enables wake-on-LAN; tcpkeepalive=1 holds TCP
# sessions during display sleep.
pmset_keys=(sleep displaysleep disksleep autorestart powernap womp tcpkeepalive)
pmset_vals=(0 10 0 1 0 1 1)

current_pmset="$(pmset -g 2>/dev/null || true)"
for i in "${!pmset_keys[@]}"; do
  key="${pmset_keys[$i]}"
  want="${pmset_vals[$i]}"
  have="$(printf '%s\n' "$current_pmset" | awk -v k="$key" '$1==k {print $2; exit}')"
  if [[ "$have" == "$want" ]]; then
    skip "pmset $key already $want"
  else
    chg "pmset $key: ${have:-unset} -> $want"
    run "sudo pmset -a $key $want"
  fi
done

# ---------- screen saver ----------

step "Screen saver"
saver_idle="$(defaults -currentHost read com.apple.screensaver idleTime 2>/dev/null || echo unset)"
if [[ "$saver_idle" == "0" ]]; then
  skip "screen saver already disabled"
else
  chg "disabling screen saver"
  run "defaults -currentHost write com.apple.screensaver idleTime -int 0"
fi

# ---------- SSH / Remote Login ----------

step "SSH / Remote Login"
if sudo systemsetup -getremotelogin 2>/dev/null | grep -qi 'On'; then
  skip "Remote Login already enabled"
else
  chg "enabling Remote Login (SSH)"
  run "sudo systemsetup -setremotelogin on"
fi

# ---------- Application Firewall ----------

step "Application Firewall"
fw="/usr/libexec/ApplicationFirewall/socketfilterfw"

if sudo "$fw" --getglobalstate 2>/dev/null | grep -qi 'enabled'; then
  skip "firewall already enabled"
else
  chg "enabling firewall"
  run "sudo $fw --setglobalstate on"
fi

if sudo "$fw" --getstealthmode 2>/dev/null | grep -qi 'enabled'; then
  skip "stealth mode already enabled"
else
  chg "enabling stealth mode"
  run "sudo $fw --setstealthmode on"
fi

# ---------- software updates (security only) ----------

step "Software updates (security only)"
su_plist="/Library/Preferences/com.apple.SoftwareUpdate"
su_keys=(AutomaticCheckEnabled AutomaticDownload CriticalUpdateInstall ConfigDataInstall AutomaticallyInstallMacOSUpdates)
su_vals=(true true true true false)

for i in "${!su_keys[@]}"; do
  key="${su_keys[$i]}"
  want="${su_vals[$i]}"
  want_int=0; [[ "$want" == "true" ]] && want_int=1
  have="$(defaults read "$su_plist" "$key" 2>/dev/null || echo unset)"
  if [[ "$have" == "$want_int" ]]; then
    skip "SoftwareUpdate $key already $want"
  else
    chg "SoftwareUpdate $key -> $want"
    run "sudo defaults write $su_plist $key -bool $want"
  fi
done

# ---------- Homebrew ----------

step "Homebrew"
if command -v brew >/dev/null 2>&1; then
  ok "Homebrew installed"
else
  chg "installing Homebrew"
  run '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  # Make brew available for the rest of this script run.
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

brew_install_if_missing() {
  local kind="$1" name="$2"
  if brew list --"$kind" "$name" >/dev/null 2>&1; then
    skip "$name already installed"
  else
    chg "installing $name"
    run "brew install --$kind $name"
  fi
}

# ---------- OrbStack ----------

step "OrbStack (container runtime)"
brew_install_if_missing cask orbstack

# ---------- Ollama ----------

step "Ollama (LaunchAgent on 0.0.0.0:11434)"
brew_install_if_missing formula ollama

ollama_plist="$HOME/Library/LaunchAgents/com.local.ollama.plist"
if [[ -f "$ollama_plist" ]]; then
  skip "Ollama LaunchAgent already at $ollama_plist"
else
  chg "writing Ollama LaunchAgent"
  if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$HOME/Library/LaunchAgents"
    cat > "$ollama_plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.local.ollama</string>
  <key>ProgramArguments</key>
  <array>
    <string>/opt/homebrew/bin/ollama</string>
    <string>serve</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>OLLAMA_HOST</key><string>0.0.0.0:11434</string>
    <key>PATH</key><string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
  </dict>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>StandardOutPath</key><string>/tmp/ollama.out.log</string>
  <key>StandardErrorPath</key><string>/tmp/ollama.err.log</string>
</dict>
</plist>
PLIST
    launchctl unload "$ollama_plist" 2>/dev/null || true
    launchctl load "$ollama_plist"
  fi
fi

# ---------- Tailscale ----------

step "Tailscale"
if [[ -d "/Applications/Tailscale.app" ]] || command -v tailscale >/dev/null 2>&1; then
  ok "Tailscale present"
else
  warn "Tailscale not installed — it's in your Brewfile; run 'brew bundle --file=$(dirname "$0")/Brewfile'"
fi

# ---------- summary ----------

step "Done — manual steps remaining"
cat <<EOF

  1. Auto-login: System Settings -> Users & Groups -> Automatic login as
     "$USER". FileVault must be off for true auto-login on boot.

  2. Tailscale: open Tailscale.app or run 'tailscale up' to authenticate
     this device against your tailnet.

  3. OrbStack: open OrbStack.app once to finish first-run setup, then
     enable "Start at login" in its settings.

  4. Tailscale ACLs: lock down Ollama (port 11434) so only trusted
     devices can reach it. Example tailnet ACL:

         {
           "action": "accept",
           "src":    ["tag:trusted"],
           "dst":    ["$HOSTNAME_NEW:11434"]
         }

  5. Pull a model once Ollama is running:
         ollama pull llama3.1:8b

  If pmset/systemsetup reported permission errors, grant your terminal
  Full Disk Access in System Settings -> Privacy & Security and re-run.

EOF
