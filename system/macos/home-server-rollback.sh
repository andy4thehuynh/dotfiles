#!/bin/bash
# home-server-rollback.sh — best-effort revert of home-server.sh.
#
# Restores the macOS settings home-server.sh changed (from the snapshot it saved
# at ~/.home-server/rollback-state.sh before its first run), stops/removes the
# llama.cpp service, and optionally uninstalls the apps it installed.
#
# What it will NOT do automatically (by design — too destructive/slow):
#   - Decrypt FileVault            (prints status + manual steps; never auto-disables)
#   - Uninstall Homebrew itself or the Xcode Command Line Tools
#   - Remove the downloaded model  (unless --purge; it's ~7-8GB and slow to refetch)
#   - Remove ~/Code/dotfiles       (unless --purge)
#
# For an EXACT full-system revert, restore the Time Machine backup / APFS snapshot
# you took before running home-server.sh — that also undoes Homebrew, the Xcode
# CLT, and FileVault, which this script intentionally leaves alone.
#
# Usage:
#   ./home-server-rollback.sh             # revert
#   ./home-server-rollback.sh --dry-run   # preview only
#   ./home-server-rollback.sh --keep-apps # don't uninstall tailscale/orbstack/llama.cpp
#   ./home-server-rollback.sh --purge     # also remove model cache + dotfiles clone

# NOTE: no `-e` — a rollback should continue past individual failures and revert
# as much as it can.
set -uo pipefail

DRY_RUN=false
KEEP_APPS=false
PURGE=false
for arg in "$@"; do
  case "$arg" in
    --dry-run)   DRY_RUN=true ;;
    --keep-apps) KEEP_APPS=true ;;
    --purge)     PURGE=true ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

step() { printf '\n==> %s\n' "$*"; }
ok()   { printf '  [ok] %s\n' "$*"; }
skip() { printf '  [skip] %s\n' "$*"; }
chg()  { printf '  [revert] %s\n' "$*"; }
warn() { printf '  [warn] %s\n' "$*"; }
run() {
  if [[ "$DRY_RUN" == true ]]; then printf '  [dry-run] %s\n' "$*"; else eval "$@"; fi
}

if [[ "$(uname)" != "Darwin" ]]; then echo "This script is for macOS only." >&2; exit 1; fi
[[ "$DRY_RUN" == true ]] && echo "[DRY RUN] No changes will be made."

# ---------- load snapshot ----------
rollback_state="$HOME/.home-server/rollback-state.sh"
if [[ ! -f "$rollback_state" ]]; then
  echo "No rollback snapshot found at $rollback_state." >&2
  echo "Either home-server.sh was never run, or it ran before snapshotting existed." >&2
  echo "Without it, restore a Time Machine backup or reinstall macOS instead." >&2
  exit 1
fi
# shellcheck disable=SC1090
source "$rollback_state"

[[ "$DRY_RUN" == false ]] && sudo -v

# Make brew available if it's installed (needed for app uninstall).
command -v brew >/dev/null 2>&1 || [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || true

fw="/usr/libexec/ApplicationFirewall/socketfilterfw"

# ---------- hostname ----------
step "Hostname"
for pair in "HostName:ORIG_HOSTNAME" "LocalHostName:ORIG_LOCALHOSTNAME" "ComputerName:ORIG_COMPUTERNAME"; do
  name="${pair%%:*}"; var="${pair##*:}"; val="${!var:-}"
  if [[ -n "$val" ]]; then
    chg "restore $name -> $val"
    run "sudo scutil --set $name \"$val\""
  else
    skip "$name had no prior value (leaving as-is)"
  fi
done

# ---------- power management ----------
step "Power management (pmset)"
for k in sleep displaysleep disksleep autorestart powernap womp tcpkeepalive; do
  var="ORIG_PMSET_${k}"; val="${!var:-unset}"
  if [[ "$val" == "unset" || -z "$val" ]]; then
    skip "pmset $k had no captured value (leaving as-is)"
  else
    chg "restore pmset $k -> $val"
    run "sudo pmset -a $k $val"
  fi
done

# ---------- screen saver ----------
step "Screen saver"
if [[ "${ORIG_SCREENSAVER_idleTime:-unset}" == "unset" ]]; then
  chg "delete screensaver idleTime override"
  run "defaults -currentHost delete com.apple.screensaver idleTime 2>/dev/null || true"
else
  chg "restore screensaver idleTime -> $ORIG_SCREENSAVER_idleTime"
  run "defaults -currentHost write com.apple.screensaver idleTime -int $ORIG_SCREENSAVER_idleTime"
fi

# ---------- SSH / Remote Login ----------
step "SSH / Remote Login"
if [[ "${ORIG_REMOTELOGIN:-Off}" == "On" ]]; then
  skip "Remote Login was On before — leaving enabled"
else
  chg "disabling Remote Login (was Off before)"
  run "sudo systemsetup -setremotelogin off"
fi

step "SSH hardening drop-in"
dropin="/etc/ssh/sshd_config.d/100-hardening.conf"
if [[ -f "$dropin" ]]; then
  chg "removing $dropin"
  run "sudo rm -f $dropin"
else
  skip "no hardening drop-in present"
fi
if [[ "${HAD_SSHD_INCLUDE:-yes}" == "no" ]]; then
  chg "removing the Include line we added to /etc/ssh/sshd_config"
  run "sudo sed -i '' '/^Include \\/etc\\/ssh\\/sshd_config\\.d\\/\\*$/d' /etc/ssh/sshd_config"
else
  skip "sshd_config already had an Include before (leaving it)"
fi

# ---------- Screen Sharing ----------
step "Screen Sharing"
ard="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
if [[ -x "$ard" ]]; then
  chg "deactivating Remote Management / Screen Sharing"
  run "sudo $ard -deactivate -configure -access -off"
else
  warn "ARD kickstart not found — disable Screen Sharing manually in System Settings"
fi

# ---------- Application Firewall ----------
step "Application Firewall"
if [[ "${ORIG_FW_GLOBAL:-off}" == "on" ]]; then
  skip "firewall was on before — leaving enabled"
else
  chg "disabling firewall (was off before)"
  run "sudo $fw --setglobalstate off"
fi
if [[ "${ORIG_FW_STEALTH:-off}" == "on" ]]; then
  skip "stealth mode was on before — leaving enabled"
else
  chg "disabling stealth mode (was off before)"
  run "sudo $fw --setstealthmode off"
fi

# ---------- login window ----------
step "Login window"
# GuestEnabled (bool)
if [[ "${ORIG_GUESTENABLED:-unset}" == "unset" ]]; then
  chg "delete loginwindow GuestEnabled"
  run "sudo defaults delete /Library/Preferences/com.apple.loginwindow GuestEnabled 2>/dev/null || true"
else
  [[ "$ORIG_GUESTENABLED" == "1" ]] && b=true || b=false
  chg "restore loginwindow GuestEnabled -> $b"
  run "sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool $b"
fi
# SHOWFULLNAME (bool)
if [[ "${ORIG_SHOWFULLNAME:-unset}" == "unset" ]]; then
  chg "delete loginwindow SHOWFULLNAME"
  run "sudo defaults delete /Library/Preferences/com.apple.loginwindow SHOWFULLNAME 2>/dev/null || true"
else
  [[ "$ORIG_SHOWFULLNAME" == "1" ]] && b=true || b=false
  chg "restore loginwindow SHOWFULLNAME -> $b"
  run "sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool $b"
fi
# RetriesUntilHint (int)
if [[ "${ORIG_RETRIESUNTILHINT:-unset}" == "unset" ]]; then
  chg "delete loginwindow RetriesUntilHint"
  run "sudo defaults delete /Library/Preferences/com.apple.loginwindow RetriesUntilHint 2>/dev/null || true"
else
  chg "restore loginwindow RetriesUntilHint -> $ORIG_RETRIESUNTILHINT"
  run "sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int $ORIG_RETRIESUNTILHINT"
fi

# ---------- software updates ----------
step "Software updates"
su_plist="/Library/Preferences/com.apple.SoftwareUpdate"
for k in AutomaticCheckEnabled AutomaticDownload CriticalUpdateInstall ConfigDataInstall AutomaticallyInstallMacOSUpdates; do
  var="ORIG_SU_${k}"; val="${!var:-unset}"
  if [[ "$val" == "unset" ]]; then
    chg "delete SoftwareUpdate $k"
    run "sudo defaults delete $su_plist $k 2>/dev/null || true"
  else
    [[ "$val" == "1" ]] && b=true || b=false
    chg "restore SoftwareUpdate $k -> $b"
    run "sudo defaults write $su_plist $k -bool $b"
  fi
done

# ---------- llama.cpp service ----------
step "llama.cpp LaunchDaemon"
llama_daemon="/Library/LaunchDaemons/com.local.llama-server.plist"
if [[ "${HAD_LLAMA_DAEMON:-no}" == "yes" ]]; then
  skip "llama daemon existed before home-server.sh — leaving it"
elif [[ -f "$llama_daemon" ]]; then
  chg "stopping + removing $llama_daemon"
  run "sudo launchctl bootout system $llama_daemon 2>/dev/null || true"
  run "sudo rm -f $llama_daemon"
else
  skip "no llama daemon present"
fi

step "llama.cpp firewall allowlist"
llama_bin="/opt/homebrew/bin/llama-server"
if [[ -x "$llama_bin" ]]; then
  chg "removing llama-server from firewall allowlist"
  run "sudo $fw --remove $llama_bin 2>/dev/null || true"
else
  skip "llama-server binary not present"
fi

step "llama.cpp logs"
chg "removing llama-server logs"
run "rm -f $HOME/Library/Logs/llama-server.out.log $HOME/Library/Logs/llama-server.err.log"
if [[ "$PURGE" == true ]]; then
  chg "purging model cache (~/llm/cache)"
  run "rm -rf $HOME/llm/cache"
else
  skip "keeping downloaded model cache (~/llm/cache) — use --purge to remove (~7-8GB)"
fi

# ---------- Homebrew apps ----------
step "Homebrew apps installed by home-server.sh"
if [[ "$KEEP_APPS" == true ]]; then
  skip "--keep-apps set; leaving tailscale/orbstack/llama.cpp installed"
elif ! command -v brew >/dev/null 2>&1; then
  warn "brew not on PATH — skipping app uninstall"
else
  for pair in "tailscale:cask:HAD_TAILSCALE" "orbstack:cask:HAD_ORBSTACK" "llama.cpp:formula:HAD_LLAMA_CPP"; do
    app="${pair%%:*}"; rest="${pair#*:}"; kind="${rest%%:*}"; var="${rest##*:}"; had="${!var:-yes}"
    if [[ "$had" == "yes" ]]; then
      skip "$app was present before home-server.sh — leaving it"
    elif brew list "$app" >/dev/null 2>&1; then
      [[ "$app" == "tailscale" ]] && warn "run 'tailscale logout' and remove the node from the Tailscale admin console too"
      chg "uninstalling $app"
      run "brew uninstall --$kind $app"
    else
      skip "$app not installed"
    fi
  done
fi

# ---------- things left alone (manual) ----------
step "Left in place (manual action if you want them gone)"
if [[ "${ORIG_FILEVAULT:-off}" == "off" ]]; then
  warn "FileVault: status now '$(fdesetup status 2>/dev/null | sed 's/.*: //')'. It was OFF before."
  warn "  To turn it off: sudo fdesetup disable   (decryption is slow; do it intentionally)"
else
  ok "FileVault was already ON before — leaving it ON"
fi
if [[ "${HAD_HOMEBREW:-no}" == "no" ]]; then
  warn "Homebrew was installed by the script and is NOT removed automatically."
  warn "  To remove: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\""
fi
warn "Xcode Command Line Tools are left installed (other tools rely on them)."
if [[ "$PURGE" == true && "${HAD_DOTFILES:-no}" == "no" ]]; then
  chg "purging ~/Code/dotfiles (cloned by the script)"
  run "rm -rf $HOME/Code/dotfiles"
else
  skip "keeping ~/Code/dotfiles (use --purge to remove if the script cloned it)"
fi

step "Rollback complete"
cat <<EOF

  Reverted the settings home-server.sh changed, from the snapshot at:
    $rollback_state

  A reboot is recommended so login-window / firewall / power changes fully apply.
  For an exact full-system revert (incl. Homebrew/Xcode/FileVault), restore the
  Time Machine backup or APFS snapshot taken before you first ran the script.

EOF
