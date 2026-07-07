#!/usr/bin/env bash
# moods Stop hook — fires when Claude finishes a turn.
# Emits a random one-liner from the ACTIVE mood as a systemMessage.
# Docs: https://code.claude.com/docs/en/hooks.md (Stop event)

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cat >/dev/null 2>&1   # drain hook payload; unused

mood=$(active_mood)
emoji=$(theme_field "$mood" emoji); [ -z "$emoji" ] && emoji="✨"
file="$MOODS_ROOT/themes/$mood/one-liners.txt"

# read non-empty lines into an array (bash 3.2 compatible — no mapfile)
lines=()
if [ -f "$file" ]; then
  while IFS= read -r l; do [ -n "$l" ] && lines+=("$l"); done < "$file"
fi
[ ${#lines[@]} -eq 0 ] && lines=("done.")

msg="${lines[$((RANDOM % ${#lines[@]}))]}"

# JSON-escape the message (quotes/backslashes) so the payload stays valid
esc=$(printf '%s' "$msg" | sed 's/\\/\\\\/g; s/"/\\"/g')

printf '{"continue": true, "suppressOutput": true, "systemMessage": "%s %s"}\n' "$emoji" "$esc"
exit 0
