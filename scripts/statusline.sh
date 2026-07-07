#!/usr/bin/env bash
# moods statusline — renders the active mood's flavor over real session info.
# Reads Claude Code session JSON on stdin.  Docs: https://code.claude.com/docs/en/statusline.md

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

input=$(cat)
mood=$(active_mood)

# --- real session fields (jq with safe fallbacks) -------------------------
model=$(printf '%s' "$input" | jq -r '.model.display_name // "Claude"')
pct=$(printf '%s' "$input"   | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
effort=$(printf '%s' "$input"| jq -r '.effort.level // "med"')
cost=$(printf '%s' "$input"  | jq -r '.cost.total_cost_usd // 0')
dir=$(printf '%s' "$input"   | jq -r '.workspace.current_dir // .cwd // ""')
dir=${dir##*/}
cost=$(printf '%.2f' "$cost" 2>/dev/null || echo "0.00")

# --- mood flavor ----------------------------------------------------------
emoji=$(theme_field "$mood" emoji); [ -z "$emoji" ] && emoji="✨"
read -r -a words <<< "$(theme_words "$mood")"
[ ${#words[@]} -eq 0 ] && words=(such very much so many wow)
pick() { echo "${words[$((RANDOM % ${#words[@]}))]}"; }

esc() { printf '\033[38;5;%sm' "$1"; }
PRIMARY=$(esc "$(theme_color "$mood" primary)")
ACCENT=$(esc "$(theme_color "$mood" accent)")
OK=$(esc "$(theme_color "$mood" ok)")
DIM=$'\033[38;5;245m'
RST=$'\033[0m'

# context color shifts as it fills: ok -> primary -> accent
if   [ "$pct" -ge 80 ]; then ctxc=$ACCENT
elif [ "$pct" -ge 50 ]; then ctxc=$PRIMARY
else                         ctxc=$OK
fi

line="$emoji "
line+="${PRIMARY}$(pick) ${model}${RST} ${DIM}·${RST} "
line+="${ctxc}$(pick) ${pct}% ctx${RST} ${DIM}·${RST} "
line+="${ACCENT}$(pick) ${effort}${RST} ${DIM}·${RST} "
line+="${PRIMARY}$(pick) \$${cost}${RST}"
[ -n "$dir" ] && line+=" ${DIM}·${RST} ${OK}$(pick) ${dir}${RST}"

printf '%b\n' "$line"
