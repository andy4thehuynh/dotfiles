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
#   - llama.cpp LLM server as a LaunchDaemon on :8080 (Gemma 4 12B, Q4),
#     starting at boot for Tailscale/LAN clients
#   - (Dotfiles apply step is present but commented out — enable later)
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
#   ./home-server-rollback.sh         # revert changes (see that script's header)
#
# Rollback: before changing anything, this script saves the prior state to
# ~/.home-server/rollback-state.sh and takes an APFS local snapshot. Run
# home-server-rollback.sh to restore. For an EXACT full-system revert, take a
# Time Machine backup before running (the only thing that also undoes Homebrew,
# the Xcode CLT, and FileVault).
#
# Security model:
#   All services (SSH, Screen Sharing, llama.cpp) should only be reachable
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

# ---------- rollback snapshot ----------
# Capture pre-change state ONCE (kept from the very first run) so
# home-server-rollback.sh can restore it. Also take an APFS local snapshot as a
# best-effort full-system safety net.
step "Rollback snapshot"
rollback_dir="$HOME/.home-server"
rollback_state="$rollback_dir/rollback-state.sh"
if [[ -f "$rollback_state" ]]; then
  skip "rollback state already captured at $rollback_state (keeping original)"
elif [[ "$DRY_RUN" == true ]]; then
  skip "would capture pre-change state -> $rollback_state"
else
  chg "capturing pre-change state -> $rollback_state"
  mkdir -p "$rollback_dir"
  chmod 700 "$rollback_dir"
  tmutil localsnapshot >/dev/null 2>&1 || warn "tmutil localsnapshot failed (non-fatal)"
  {
    echo "# home-server.sh rollback state — captured $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "ORIG_HOSTNAME=$(printf '%q' "$(scutil --get HostName 2>/dev/null || echo)")"
    echo "ORIG_LOCALHOSTNAME=$(printf '%q' "$(scutil --get LocalHostName 2>/dev/null || echo)")"
    echo "ORIG_COMPUTERNAME=$(printf '%q' "$(scutil --get ComputerName 2>/dev/null || echo)")"
    for k in sleep displaysleep disksleep autorestart powernap womp tcpkeepalive; do
      v="$(pmset -g 2>/dev/null | awk -v k="$k" '$1==k {print $2; exit}')"
      echo "ORIG_PMSET_${k}=$(printf '%q' "${v:-unset}")"
    done
    echo "ORIG_SCREENSAVER_idleTime=$(printf '%q' "$(defaults -currentHost read com.apple.screensaver idleTime 2>/dev/null || echo unset)")"
    echo "ORIG_REMOTELOGIN=$(printf '%q' "$(sudo systemsetup -getremotelogin 2>/dev/null | sed 's/.*: //')")"
    echo "ORIG_FW_GLOBAL=$(sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null | grep -qi enabled && echo on || echo off)"
    echo "ORIG_FW_STEALTH=$(sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode 2>/dev/null | grep -qi enabled && echo on || echo off)"
    echo "ORIG_GUESTENABLED=$(printf '%q' "$(sudo defaults read /Library/Preferences/com.apple.loginwindow GuestEnabled 2>/dev/null || echo unset)")"
    echo "ORIG_SHOWFULLNAME=$(printf '%q' "$(sudo defaults read /Library/Preferences/com.apple.loginwindow SHOWFULLNAME 2>/dev/null || echo unset)")"
    echo "ORIG_RETRIESUNTILHINT=$(printf '%q' "$(sudo defaults read /Library/Preferences/com.apple.loginwindow RetriesUntilHint 2>/dev/null || echo unset)")"
    for k in AutomaticCheckEnabled AutomaticDownload CriticalUpdateInstall ConfigDataInstall AutomaticallyInstallMacOSUpdates; do
      echo "ORIG_SU_${k}=$(printf '%q' "$(defaults read /Library/Preferences/com.apple.SoftwareUpdate $k 2>/dev/null || echo unset)")"
    done
    echo "ORIG_FILEVAULT=$(fdesetup status 2>/dev/null | grep -qi 'On' && echo on || echo off)"
    echo "HAD_HOMEBREW=$(command -v brew >/dev/null 2>&1 && echo yes || echo no)"
    echo "HAD_SSHD_INCLUDE=$(grep -qE '^[[:space:]]*Include[[:space:]]+/etc/ssh/sshd_config\.d/' /etc/ssh/sshd_config 2>/dev/null && echo yes || echo no)"
    echo "HAD_DOTFILES=$([[ -d "$HOME/Code/dotfiles/.git" ]] && echo yes || echo no)"
    echo "HAD_LLAMA_DAEMON=$([[ -f /Library/LaunchDaemons/com.local.llama-server.plist ]] && echo yes || echo no)"
    for app in tailscale orbstack llama.cpp; do
      if command -v brew >/dev/null 2>&1 && brew list "$app" >/dev/null 2>&1; then had=yes; else had=no; fi
      echo "HAD_$(echo "$app" | tr 'a-z.' 'A-Z_')=$had"
    done
  } > "$rollback_state"
  chmod 600 "$rollback_state"
  warn "Snapshot saved. To revert later: ./home-server-rollback.sh"
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
  # macOS's stock sshd_config doesn't always Include the drop-in dir. Without
  # this line our hardening file is silently ignored — so ensure it's present.
  if ! grep -qE '^[[:space:]]*Include[[:space:]]+/etc/ssh/sshd_config\.d/' "$sshd_config" 2>/dev/null; then
    chg "adding Include for /etc/ssh/sshd_config.d/* to $sshd_config"
    printf '\nInclude /etc/ssh/sshd_config.d/*\n' | sudo tee -a "$sshd_config" > /dev/null
  else
    skip "$sshd_config already Includes sshd_config.d"
  fi
fi

sshd_hardening_lines=(
  "PermitRootLogin no"
  "PubkeyAuthentication yes"
  "MaxAuthTries 3"
  "LoginGraceTime 30"
  "X11Forwarding no"
  "AllowAgentForwarding yes"
)

# Enforce publickey-only ONLY after key auth is confirmed AND a key is present —
# otherwise this would lock you out of SSH. Until then, leave password auth as a
# fallback. (Setting AuthenticationMethods publickey overrides PasswordAuthentication,
# so we must not add it before a key exists.)
auth_keys="$HOME/.ssh/authorized_keys"
if [[ "$SSH_DISABLE_PASSWORD" == "true" ]]; then
  if [[ -s "$auth_keys" ]]; then
    sshd_hardening_lines+=(
      "AuthenticationMethods publickey"
      "PasswordAuthentication no"
      "KbdInteractiveAuthentication no"
    )
  else
    warn "SSH_DISABLE_PASSWORD=true but $auth_keys is empty — refusing to enforce"
    warn "publickey-only (would lock you out). Add your public key first, then re-run."
  fi
else
  warn "SSH password auth still enabled (safe default). After 'ssh-copy-id' works,"
  warn "re-run with SSH_DISABLE_PASSWORD=true to enforce publickey-only."
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
  # Omit -restart so re-running this script over Screen Sharing doesn't drop your
  # own session. Config changes apply on the next agent start.
  run "sudo $ard_kickstart -activate -configure -access -on -privs -all -users $USER -agent -menu"
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
      # -defer writes the recovery key to a plist on next login. Keep it OUT of
      # world-readable /tmp (also wiped on reboot) — use a private path instead.
      fv_key="$HOME/.config/filevault-recovery-key.plist"
      mkdir -p "$HOME/.config"
      chmod 700 "$HOME/.config"
      sudo fdesetup enable -user "$USER" -defer "$fv_key"
      warn "Recovery key will be written to $fv_key on next login — chmod it 600."
      warn "Move it to your password manager and delete the file. Without it, data is unrecoverable."
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

# ---------- Dotfiles apply (DISABLED for now) ----------
# Cloning the repo above does NOT activate any config by itself. Leave this
# commented out until you want your personal config on the server, then
# uncomment and adjust the list to match your repo layout. It's idempotent
# (skips links that already point at the right source).
#
# step "Dotfiles apply"
# dotfiles_links=(
#   ".zshrc"
#   ".gitconfig"
#   ".tmux.conf"
#   ".config/nvim"
# )
# for rel in "${dotfiles_links[@]}"; do
#   src="$HOME/Code/dotfiles/$rel"
#   dst="$HOME/$rel"
#   [[ -e "$src" ]] || { warn "dotfile source missing: $src"; continue; }
#   if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
#     skip "linked $rel"
#   else
#     chg "linking $rel -> $src"
#     run "mkdir -p \"$(dirname \"$dst\")\""
#     run "ln -sfn \"$src\" \"$dst\""
#   fi
# done

# ---------- Homebrew ----------

step "Homebrew"
if command -v brew >/dev/null 2>&1; then
  ok "Homebrew installed"
else
  chg "installing Homebrew"
  run 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
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

# ---------- llama.cpp (LLM inference server) ----------

step "llama.cpp"
brew_install_if_missing formula llama.cpp

# Model cache + log dirs (owned by the login user; the daemon runs as that user).
llama_bin="/opt/homebrew/bin/llama-server"
llama_cache="$HOME/llm/cache"
llama_logs="$HOME/Library/Logs"
if [[ "$DRY_RUN" == false ]]; then
  mkdir -p "$llama_cache" "$llama_logs"
fi

# Allow the llama-server binary to receive inbound connections through the
# Application Firewall — otherwise the firewall blocks the headless daemon and
# Tailscale/LAN clients can't reach :8080.
step "llama.cpp — firewall allowlist"
if [[ -x "$llama_bin" ]]; then
  run "sudo $fw --add $llama_bin"
  run "sudo $fw --unblockapp $llama_bin"
else
  warn "llama-server not found at $llama_bin yet — firewall allow will apply on next run after install."
fi

# LaunchDaemon: starts at boot (after FileVault unlock), no GUI login required.
# Serves Gemma 4 12B (Q4) on :8080. Rationale: plans/gemma4.md + decisions.md (D6).
step "llama.cpp — LaunchDaemon (Gemma 4 on :8080)"
llama_daemon="/Library/LaunchDaemons/com.local.llama-server.plist"
if [[ -f "$llama_daemon" ]]; then
  skip "llama-server LaunchDaemon already at $llama_daemon"
else
  chg "writing llama-server LaunchDaemon -> $llama_daemon"
  if [[ "$DRY_RUN" == false ]]; then
    sudo tee "$llama_daemon" > /dev/null <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.local.llama-server</string>
  <key>UserName</key><string>$USER</string>
  <key>ProgramArguments</key>
  <array>
    <string>$llama_bin</string>
    <string>-hf</string><string>unsloth/gemma-4-12b-it-GGUF:UD-Q4_K_XL</string>
    <string>--host</string><string>0.0.0.0</string>
    <string>--port</string><string>8080</string>
    <string>--n-gpu-layers</string><string>99</string>
    <string>--ctx-size</string><string>8192</string>
    <string>--flash-attn</string><string>on</string>
    <string>--temp</string><string>1.0</string>
    <string>--top-p</string><string>0.95</string>
    <string>--top-k</string><string>64</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>HOME</key><string>$HOME</string>
    <key>LLAMA_CACHE</key><string>$llama_cache</string>
    <key>PATH</key><string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
  </dict>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>StandardOutPath</key><string>$llama_logs/llama-server.out.log</string>
  <key>StandardErrorPath</key><string>$llama_logs/llama-server.err.log</string>
</dict>
</plist>
PLIST
    sudo chown root:wheel "$llama_daemon"
    sudo chmod 644 "$llama_daemon"
    sudo launchctl bootstrap system "$llama_daemon" 2>/dev/null \
      || sudo launchctl load -w "$llama_daemon"
    warn "First start downloads the Gemma 4 model (~7-8GB) — :8080 is ready once that finishes."
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
           "dst":    ["$HOSTNAME_NEW:22,5900,8080"]
         }

     Ports: 22=SSH, 5900=Screen Sharing, 8080=llama.cpp (Gemma 4)

  5. Screen Sharing: from your MacBook, open Finder -> Go -> Connect to
     Server -> vnc://$HOSTNAME_NEW.tail<your-tailnet>.ts.net
     Or use System Settings -> General -> Sharing to verify it's on.

  6. LLM: the llama.cpp LaunchDaemon serves Gemma 4 on :8080 automatically.
     First boot downloads the model (~7-8GB). Watch progress:
         tail -f ~/Library/Logs/llama-server.err.log
     Confirm it's up:
         curl http://127.0.0.1:8080/health      # {"status":"ok"} when ready

  7. FileVault: currently $(fdesetup status 2>/dev/null || echo "unknown").
     Kept ON by choice (encryption at rest). Note: each reboot pauses at the
     unlock screen until the password is entered at the console, so the server
     does not return fully unattended after a power loss.

  If pmset/systemsetup reported permission errors, grant your terminal
  Full Disk Access in System Settings -> Privacy & Security and re-run.

EOF
