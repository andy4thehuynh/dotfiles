#!/usr/bin/env bash
# Status line: model, effort, context-window usage, vim mode, git branch/dirty
# state, session cost, and rolling rate limits — all computed inline, colored
# with Catppuccin Mocha's own hex values (24-bit ANSI truecolor, no Nerd Font
# glyphs needed, no starship/starship-claude dependency).
#
# Fields absent early in a session (context_window, rate_limits) come back
# null from Claude Code, hence the -1 sentinel and the "if present" guards
# below rather than treating 0 as a real value.
set -euo pipefail

payload="$(cat)"

# \x1f (unit separator) rather than a tab: bash's `read` treats consecutive
# tabs as a single delimiter and silently shifts fields when one is empty.
IFS=$'\x1f' read -r model dir cost ctx_pct effort vim rl5 rl7 <<<"$(jq -r '
  [
    (.model.display_name // "?"),
    (.workspace.current_dir // .cwd // ""),
    (.cost.total_cost_usd // 0),
    (.context_window.used_percentage // -1 | round),
    (.effort.level // ""),
    (.vim.mode // ""),
    (.rate_limits.five_hour.used_percentage // -1 | round),
    (.rate_limits.seven_day.used_percentage // -1 | round)
  ] | join("")
' <<<"$payload" 2>/dev/null)"

RESET=$'\e[0m'
# Catppuccin Mocha (https://catppuccin.com/palette), 24-bit foreground escapes.
LAVENDER=$'\e[38;2;180;190;254m' # model
CLAUDE=$'\e[38;2;217;119;87m'    # effort: fallback (Anthropic brand orange), git branch
TEAL=$'\e[38;2;148;226;213m'     # effort: low
SAPPHIRE=$'\e[38;2;116;199;236m' # effort: medium
FLAMINGO=$'\e[38;2;242;205;205m' # effort: high
PINK=$'\e[38;2;245;194;231m'     # effort: xhigh
ROSEWATER=$'\e[38;2;245;224;220m' # model: fable
BLUE=$'\e[38;2;137;180;250m'     # vim: NORMAL
MAUVE=$'\e[38;2;203;166;247m'    # vim: VISUAL
RED=$'\e[38;2;243;139;168m'      # vim: REPLACE
SKY=$'\e[38;2;137;220;235m'      # vim: anything else
GREEN=$'\e[38;2;166;227;161m'    # cost
YELLOW=$'\e[38;2;249;226;175m'   # vim: INSERT
OVERLAY=$'\e[38;2;108;112;134m'  # separators
GREY=$'\e[38;2;166;173;200m'     # rate limits: under threshold
PEACH=$'\e[38;2;250;179;135m'    # working directory

# Nerd Font glyphs (codepoints verified against FiraCodeNerdFontMono's own cmap).
EFFORT_ICON=$'\U000f04c5'  # md-speedometer
CONTEXT_ICON=$'\U000f035b' # md-memory
BRANCH_ICON=$'\uf418'      # oct-git_branch
COST_ICON=$'\U000f0114'    # md-cash
RATE_ICON=$'\U000f0150'    # md-clock_outline
DIR_ICON=$'\U000f024b'     # md-folder

case "${model,,}" in
  *haiku*) model_icon=$'\uee0d ' ; model_color="$SKY" ;;
  *opus*) model_icon=$'\U000f16a6 ' ; model_color="$MAUVE" ;;
  *fable*) model_icon=$'\U000f06a9 ' ; model_color="$ROSEWATER" ;;
  *) model_icon=$'\U000f06a9 ' ; model_color="$LAVENDER" ;; # sonnet, and default for anything unrecognized
esac

segments=()

if [[ -n "$vim" ]]; then
  case "${vim^^}" in
    NORMAL) vim_color="$BLUE" ;;
    INSERT) vim_color="$GREEN" ;;
    VISUAL*) vim_color="$MAUVE" ;; # VISUAL, VISUAL_LINE, VISUAL_BLOCK
    REPLACE) vim_color="$RED" ;;
    *) vim_color="$YELLOW" ;; # command-line, terminal, select mode
  esac
  segments+=("${vim_color}[${vim:0:1}]${RESET}")
fi

[[ -n "$dir" ]] && segments+=("${PEACH}${DIR_ICON} $(basename "$dir")${RESET}")

branch=""
dirty=""
if [[ -n "$dir" ]] && git -C "$dir" rev-parse --is-inside-work-tree &>/dev/null; then
  branch="$(git -C "$dir" branch --show-current 2>/dev/null)"
  [[ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ]] && dirty="*"
fi
[[ -n "$branch" ]] && segments+=("${CLAUDE}${BRANCH_ICON} ${branch}${dirty}${RESET}")

segments+=("${model_color}${model_icon}${model}${RESET}")

if [[ -n "$effort" ]]; then
  case "${effort,,}" in
    low) effort_color="$TEAL" ;;
    medium) effort_color="$SAPPHIRE" ;;
    high) effort_color="$FLAMINGO" ;;
    xhigh) effort_color="$PINK" ;;
    max) effort_color="$RED" ;;
    ultracode) effort_color="$BLUE" ;;
    *) effort_color="$CLAUDE" ;;
  esac
  segments+=("${effort_color}${EFFORT_ICON} ${effort}${RESET}")
fi

[[ "$ctx_pct" != "-1" ]] && segments+=("${SKY}${CONTEXT_ICON} ${ctx_pct}%${RESET}")

RATE_THRESHOLD=75
if [[ "$rl5" != "-1" || "$rl7" != "-1" ]]; then
  rl=""
  if [[ "$rl5" != "-1" ]]; then
    color="$GREY"; ((rl5 > RATE_THRESHOLD)) && color="$RED"
    rl+="${color}5h:${rl5}%${RESET}"
  fi
  if [[ "$rl7" != "-1" ]]; then
    [[ -n "$rl" ]] && rl+=" "
    color="$GREY"; ((rl7 > RATE_THRESHOLD)) && color="$RED"
    rl+="${color}7d:${rl7}%${RESET}"
  fi
  segments+=("${GREY}${RATE_ICON} ${RESET}${rl}")
fi

segments+=("${GREEN}${COST_ICON} \$$(printf '%.2f' "$cost")${RESET}")

out="${segments[0]}"
for s in "${segments[@]:1}"; do
  out+=" ${OVERLAY}│${RESET} ${s}"
done
printf '%s\n' "$out"
