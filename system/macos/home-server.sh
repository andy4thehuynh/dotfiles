#!/bin/bash
# home-server.sh — provisions a Mac Mini as a headless home server.
#
# Idempotent: every step checks state before changing it. Safe to re-run.
#
# What this configures:
#   - Hostname (HostName, LocalHostName, ComputerName)
#   - Power management (pmset): never sleep, auto-restart, wake-on-LAN
#   - Screen saver disabled, display sleep at 10 min
#   - SSH / Remote Login enabled + hardened (key-only, no root, no password)
#   - Screen Sharing enabled (for VNC from MacBook over Tailscale)
#   - Application Firewall on, stealth mode on
#   - Login window hardened (guest disabled, name+password prompt)
#   - FileVault (configurable — see FILEVAULT_ENABLE below)
#   - Software updates: security/data only (no unattended OS upgrades)
#   - Homebrew (installed if missing)
#   - Tailscale (installed via Homebrew cask)
#   - OrbStack (container runtime, lighter than Docker Desktop)
#   - Ollama with a LaunchAgent binding 0.0.0.0:11434 for Tailscale clients
#
# Before running this script (manual steps on the Mac Mini):
#
#   1. Enable Screen Sharing so you can access the Mac Mini from your MacBook:
#        System Settings → General → Sharing → Screen Sharing — toggle it ON
#        Note the Mac Mini's local IP address:
#          System Settings → Wi-Fi (or Network) — it's listed under the connection
#        From your MacBook: Screen Sharing app → connect to that IP address
#
#   2. Create the Code directory and clone your dotfiles:
#        mkdir -p ~/Code
#        git clone https://github.com/andy4thehuynh/dotfiles.git ~/Code/dotfiles
#        cd ~/Code/dotfiles/system/macos && ./home-server.sh
#
# Manual steps still required (printed at the end):
#   - Copy your SSH public key to this machine before enabling key-only auth
#   - Authenticate Tailscale on this device
#   - Run OrbStack.app once to complete first-run setup
#   - Restrict who can reach services via Tailscale ACLs
#   - Grant Full Disk Access to Terminal/iTerm if pmset/systemsetup steps
#     report permission errors
#
# Usage:
#   ./home-server.sh                  # apply
#   ./home-server.sh --dry-run        # preview without changing anything
#   HOSTNAME_NEW=mini ./home-server.sh
#
# Security model:
#   All services (SSH, Screen Sharing, Ollama) should only be reachable
#   over your Tailscale network. The macOS firewall + stealth mode blocks
#   unsolicited LAN traffic. Tailscale ACLs are your primary access control.
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

# ---------- config flags ----------
# Set to "true" to enable FileVault disk encryption.
# Trade-off: FileVault ON = encrypted at rest (good for security),
# but auto-login after power loss won't work — you'd need to type the
# password at the login screen or use an MDM to escrow the recovery key.
# For a single-user home server behind Tailscale, this is your call.
FILEVAULT_ENABLE="${FILEVAULT_ENABLE:-false}"

# Set to "true" ONLY after you've confirmed SSH key auth works.
# If you lock yourself out, you'll need physical access + Screen Sharing.
SSH_DISABLE_PASSWORD="${SSH_DISABLE_PASSWORD:-false}"

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

# ---------- SSH hardening ----------

step "SSH hardening"
sshd_config="/etc/ssh/sshd_config"

# Helper: set or add an sshd_config directive idempotently.
# Uses a drop-in file so we don't clobber the stock sshd_config.
sshd_dropin="/etc/ssh/sshd_config.d/100-hardening.conf"

if [[ "$DRY_RUN" == false ]]; then
  sudo mkdir -p /etc/ssh/sshd_config.d
fi

sshd_hardening_lines=(
  "PermitRootLogin no"
  "PubkeyAuthentication yes"
  "AuthenticationMethods publickey"
  "MaxAuthTries 3"
  "LoginGraceTime 30"
  "X11Forwarding no"
  "AllowAgentForwarding yes"
)

# Only disable password auth if the flag is set (after you've confirmed
# key-based auth works). Otherwise leave password auth on as a fallback.
if [[ "$SSH_DISABLE_PASSWORD" == "true" ]]; then
  sshd_hardening_lines+=(
    "PasswordAuthentication no"
    "KbdInteractiveAuthentication no"
  )
else
  warn "SSH password auth still enabled. Set SSH_DISABLE_PASSWORD=true after confirming key auth works."
fi

desired_content=""
for line in "${sshd_hardening_lines[@]}"; do
  desired_content+="$line"$'\n'
done

if [[ -f "$sshd_dropin" ]] && diff -q <(echo "$desired_content") "$sshd_dropin" >/dev/null 2>&1; then
  skip "SSH hardening drop-in already matches"
else
  chg "writing SSH hardening drop-in -> $sshd_dropin"
  if [[ "$DRY_RUN" == false ]]; then
    echo "$desired_content" | sudo tee "$sshd_dropin" > /dev/null
    sudo chmod 644 "$sshd_dropin"
  fi
fi

# Ensure the authorized_keys file exists for the current user.
auth_keys="$HOME/.ssh/authorized_keys"
if [[ -f "$auth_keys" ]]; then
  skip "authorized_keys exists at $auth_keys"
else
  chg "creating $auth_keys (add your public keys here)"
  if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$HOME/.ssh"
    touch "$auth_keys"
    chmod 700 "$HOME/.ssh"
    chmod 600 "$auth_keys"
  fi
fi

# ---------- Screen Sharing ----------

step "Screen Sharing (VNC)"
# Screen Sharing is the com.apple.screensharing launchd service.
# Controlled via launchctl or `sudo defaults write` to the VNC plist.
if sudo launchctl list com.apple.screensharing 2>/dev/null | grep -q 'PID'; then
  skip "Screen Sharing already running"
elif sudo launchctl list com.apple.screensharing >/dev/null 2>&1; then
  # Service is loaded but not running — just needs a kick.
  skip "Screen Sharing service loaded (may start on next connection)"
else
  chg "enabling Screen Sharing"
  run "sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist 2>/dev/null || true"
fi

# Restrict Screen Sharing to the current user only (not all users).
# This writes to the VNC preference domain.
step "Screen Sharing — restrict to current user"
vnc_plist="/Library/Preferences/com.apple.RemoteManagement"
# The cleanest way on modern macOS: use kickstart from ARD's command line.
ard_kickstart="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
if [[ -x "$ard_kickstart" ]]; then
  chg "configuring ARD/Screen Sharing for user $USER with observe+control"
  run "sudo $ard_kickstart -activate -configure -access -on -privs -all -users $USER -restart -agent -menu"
else
  warn "ARD kickstart not found — enable Screen Sharing manually in System Settings -> General -> Sharing"
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

# ---------- login window hardening ----------

step "Login window hardening"

# Disable guest account.
guest_enabled="$(sudo defaults read /Library/Preferences/com.apple.loginwindow GuestEnabled 2>/dev/null || echo unset)"
if [[ "$guest_enabled" == "0" ]]; then
  skip "guest account already disabled"
else
  chg "disabling guest account"
  run "sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false"
fi

# Show login as Name and Password (not user list) — hides valid usernames.
login_text="$(sudo defaults read /Library/Preferences/com.apple.loginwindow SHOWFULLNAME 2>/dev/null || echo unset)"
if [[ "$login_text" == "1" ]]; then
  skip "login window already shows Name and Password prompt"
else
  chg "login window -> show Name and Password fields"
  run "sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true"
fi

# Disable password hints.
hints="$(sudo defaults read /Library/Preferences/com.apple.loginwindow RetriesUntilHint 2>/dev/null || echo unset)"
if [[ "$hints" == "0" ]]; then
  skip "password hints already disabled"
else
  chg "disabling password hints at login window"
  run "sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0"
fi

# ---------- FileVault ----------

step "FileVault (disk encryption)"
fv_status="$(fdesetup status 2>/dev/null || echo "unknown")"
if [[ "$FILEVAULT_ENABLE" == "true" ]]; then
  if echo "$fv_status" | grep -qi 'On'; then
    skip "FileVault already enabled"
  else
    chg "enabling FileVault — SAVE THE RECOVERY KEY"
    if [[ "$DRY_RUN" == false ]]; then
      # -defer writes recovery key to a plist on next login.
      sudo fdesetup enable -user "$USER" -defer /tmp/filevault-recovery-key.plist
      warn "Recovery key will be generated on next login. Check /tmp/filevault-recovery-key.plist"
      warn "Store this key securely (password manager, printed copy). Without it, data is unrecoverable."
    fi
  fi
else
  if echo "$fv_status" | grep -qi 'On'; then
    warn "FileVault is ON but FILEVAULT_ENABLE=false. Not disabling automatically — do this manually if intended."
  else
    skip "FileVault disabled (FILEVAULT_ENABLE=false). Trade-off: no encryption at rest."
  fi
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

# ---------- Xcode CLI Tools ----------

step "Xcode Command Line Tools (required for git)"
if xcode-select -p >/dev/null 2>&1; then
  ok "Xcode CLI tools already installed"
else
  chg "installing Xcode CLI tools"
  run "xcode-select --install"
  # Wait for the install to complete before continuing.
  if [[ "$DRY_RUN" == false ]]; then
    until xcode-select -p >/dev/null 2>&1; do sleep 5; done
    ok "Xcode CLI tools installed"
  fi
fi

# ---------- Dotfiles ----------

step "Dotfiles (~/Code/dotfiles)"
if [[ "$DRY_RUN" == false ]]; then
  mkdir -p "$HOME/Code"
fi

if [[ -d "$HOME/Code/dotfiles/.git" ]]; then
  skip "dotfiles repo already cloned at ~/Code/dotfiles"
else
  chg "cloning dotfiles into ~/Code/dotfiles"
  run "git clone https://github.com/andy4thehuynh/dotfiles.git \"$HOME/Code/dotfiles\""
fi

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

# ---------- Tailscale ----------

step "Tailscale"
brew_install_if_missing cask tailscale

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

# ---------- summary ----------

step "Done — manual steps remaining"
cat <<EOF

  ── POST-INSTALL CHECKLIST ──

  1. SSH key setup (do this FIRST, before disabling password auth):
       # From your MacBook or ThinkPad:
       ssh-copy-id $USER@$HOSTNAME_NEW    # over Tailscale IP or .ts.net name
       ssh $USER@$HOSTNAME_NEW            # confirm key auth works

       # Then re-run this script with password auth disabled:
       SSH_DISABLE_PASSWORD=true ./home-server.sh

  2. Tailscale: open Tailscale.app or run 'tailscale up' to authenticate
     this device against your tailnet.

  3. OrbStack: open OrbStack.app once to finish first-run setup, then
     enable "Start at login" in its settings.

  4. Tailscale ACLs: lock down services so only your devices can reach them.
     Example:
         {
           "action": "accept",
           "src":    ["tag:trusted"],
           "dst":    ["$HOSTNAME_NEW:22,5900,11434"]
         }

     Ports: 22=SSH, 5900=Screen Sharing, 11434=Ollama

  5. Screen Sharing: from your MacBook, open Finder -> Go -> Connect to
     Server -> vnc://$HOSTNAME_NEW.tail<your-tailnet>.ts.net
     Or use System Settings -> General -> Sharing to verify it's on.

  6. Pull a model once Ollama is running:
         ollama pull llama3.1:8b

  7. FileVault: currently $(fdesetup status 2>/dev/null || echo "unknown").
     To enable: FILEVAULT_ENABLE=true ./home-server.sh
     Trade-off: encryption at rest vs. auto-login after power loss.

  If pmset/systemsetup reported permission errors, grant your terminal
  Full Disk Access in System Settings -> Privacy & Security and re-run.

EOF
