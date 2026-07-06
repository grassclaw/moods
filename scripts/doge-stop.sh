#!/usr/bin/env bash
# doge-code Stop hook — fires when Claude finishes a turn. wow. very done.
# Emits a random doge one-liner as a systemMessage so it surfaces in the UI.
# Docs: https://code.claude.com/docs/en/hooks.md (Stop event)

# consume stdin (hook payload) so the pipe doesn't block; we don't need it
cat >/dev/null 2>&1

lines=(
  "wow. such complete. very answer."
  "much done. so finish. amaze."
  "very turn. much resolve. wow."
  "such task. many done. very good boy."
  "so ship. much wow. very Aaron."
  "amaze. task = complete. much proud."
  "wow. very code. such works (probably)."
  "many keystrokes. such effort. wow."
)

# vary selection without Math.random-style state; $RANDOM is fine in a hook script
msg="${lines[$((RANDOM % ${#lines[@]}))]}"

# exit 0 + JSON on stdout => non-blocking; systemMessage is surfaced to the user
printf '{"continue": true, "suppressOutput": true, "systemMessage": "🐕 %s"}\n' "$msg"
exit 0
