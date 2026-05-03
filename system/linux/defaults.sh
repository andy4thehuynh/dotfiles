#!/bin/bash
# system/linux/defaults.sh — GNOME desktop defaults for Omakub/ThinkPad
#
# Configures keyboard remapping, workspace management, and window hotkeys
# to match Aerospace (macOS) muscle memory. Run once after fresh install,
# or re-run to reset. Safe to run multiple times (idempotent).
#
# Usage: ./system/linux/defaults.sh

set -e

echo "==> Applying GNOME defaults..."

##########################################################
# Keyboard remapping
##########################################################
# Caps Lock → Ctrl:      same as macOS "modifier keys" remap
# Alt ↔ Super swap:      physical Alt sends Super, physical Win sends Alt
#                         This means Aerospace's alt-<key> muscle memory
#                         maps to GNOME's Super-<key> bindings naturally.
#
# Linux gotcha: xkb-options is an ARRAY — you set all options in one call.
# Setting it again replaces the whole array, it doesn't append.

echo "  [keyboard] Caps Lock → Ctrl, Alt ↔ Super swap"
gsettings set org.gnome.desktop.input-sources xkb-options \
  "['caps:ctrl_modifier', 'altwin:swap_alt_win']"

##########################################################
# Disable Super key overlay (Activities)
##########################################################
# Without this, tapping the physical Alt key (now mapped to Super) opens
# the Activities overview on every quick press. We only want Super to work
# as a modifier in combos like Super+1, not as a standalone trigger.

echo "  [keyboard] Disable Super overlay (Activities trigger)"
gsettings set org.gnome.mutter overlay-key ''

##########################################################
# Workspaces: fixed, 10 total (matches Aerospace 1–10)
##########################################################
# GNOME defaults to dynamic workspaces. Fixed workspaces are more
# predictable and match the numbered-workspace model from Aerospace.

echo "  [workspaces] Fixed, 10 total"
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10

# Workspaces span all monitors (not just the primary)
gsettings set org.gnome.mutter workspaces-only-on-primary false

##########################################################
# Workspace switching: Super+1..9
# Mirrors: Aerospace alt-1..9 = 'workspace 1..9'
##########################################################

echo "  [hotkeys] Super+1..9 → switch workspace"
for i in $(seq 1 9); do
  # Clear any conflicting defaults (GNOME sometimes binds Super+N to other things)
  gsettings set org.gnome.shell.keybindings "switch-to-application-${i}" "[]"
  gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-${i}" "['<Super>${i}']"
done

# Super+0 → workspace 10 (mirrors Aerospace alt-0 = 'workspace 0')
gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-10" "['<Super>0']"

##########################################################
# Move window to workspace: Super+Shift+1..9
# Mirrors: Aerospace alt-shift-1..9 = 'move-node-to-workspace 1..9'
##########################################################

echo "  [hotkeys] Super+Shift+1..9 → move window to workspace"
for i in $(seq 1 9); do
  gsettings set org.gnome.desktop.wm.keybindings "move-to-workspace-${i}" "['<Super><Shift>${i}']"
done

# Super+Shift+0 → move to workspace 10
gsettings set org.gnome.desktop.wm.keybindings "move-to-workspace-10" "['<Super><Shift>0']"

##########################################################
# Window management
##########################################################
# Super+W         → close window     (Aerospace: alt-w)
# Super+Up        → maximize         (GNOME default, keeping it)
# Super+BackSpace → begin resize     (Omakub convention)

echo "  [hotkeys] Window management (close, maximize, resize)"
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"
gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings begin-resize "['<Super>BackSpace']"

##########################################################
# Super+Tab → workspace back-and-forth
# Mirrors: Aerospace alt-tab = 'workspace-back-and-forth'
##########################################################
# TODO: GNOME has no native "return to previous workspace" toggle.
# This needs a GNOME extension (e.g., "Auto Move Windows" or a custom one).
# For now, unbind GNOME's default Super+Tab (app switcher) so the binding
# is free when we add the extension. Window switching still works via
# Alt+Tab (physical Windows key + Tab after the swap).

echo "  [hotkeys] Unbind Super+Tab (reserved for workspace back-and-forth)"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"

echo ""
echo "Done. Log out and back in for keyboard remapping to take full effect."
echo ""
echo "Post-swap physical key reference:"
echo "  Physical Alt   → sends Super (use for WM: workspaces, close, etc.)"
echo "  Physical Win   → sends Alt   (use for window switching: Alt+Tab)"
echo "  Physical Caps  → sends Ctrl"
