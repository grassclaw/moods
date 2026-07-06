#!/usr/bin/env bash
# doge-code statusline — much status. very line. wow.
# Reads the Claude Code session JSON on stdin and renders a doge-flavored line.
# Docs: https://code.claude.com/docs/en/statusline.md

input=$(cat)

# --- pull real session fields (jq with safe fallbacks) --------------------
model=$(printf '%s' "$input" | jq -r '.model.display_name // "Claude"')
pct=$(printf '%s' "$input"   | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
effort=$(printf '%s' "$input"| jq -r '.effort.level // "med"')
cost=$(printf '%s' "$input"  | jq -r '.cost.total_cost_usd // 0')
dir=$(printf '%s' "$input"   | jq -r '.workspace.current_dir // .cwd // ""')
dir=${dir##*/}   # basename only

# format cost to 2 decimals
cost=$(printf '%.2f' "$cost" 2>/dev/null || echo "0.00")

# --- doge intensifiers — pick a fresh set each render ---------------------
words=(such very much so many wow lil smol big)
pick() { echo "${words[$((RANDOM % ${#words[@]}))]}"; }

# --- colors (doge palette: comic-gold + shibe-magenta) --------------------
GOLD=$'\033[38;5;220m'
PINK=$'\033[38;5;213m'
GREEN=$'\033[38;5;114m'
DIM=$'\033[38;5;245m'
RST=$'\033[0m'

# context color shifts as it fills: green -> gold -> pink
if   [ "$pct" -ge 80 ]; then ctxc=$PINK
elif [ "$pct" -ge 50 ]; then ctxc=$GOLD
else                         ctxc=$GREEN
fi

# --- assemble: 🐕 such Opus · wow 8% context · very high · much $0.01 ------
line="🐕 "
line+="${GOLD}$(pick) ${model}${RST} ${DIM}·${RST} "
line+="${ctxc}$(pick) ${pct}% ctx${RST} ${DIM}·${RST} "
line+="${PINK}$(pick) ${effort}${RST} ${DIM}·${RST} "
line+="${GOLD}$(pick) \$${cost}${RST}"
[ -n "$dir" ] && line+=" ${DIM}·${RST} ${GREEN}$(pick) ${dir}${RST}"

printf '%b\n' "$line"
