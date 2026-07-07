#!/usr/bin/env bash
# moods — shared helpers. Resolves the active mood + its theme pack.
# Sourced by statusline.sh and stop.sh.

# Root of the plugin (scripts/ lives directly under it).
MOODS_ROOT="${MOODS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# Where the active mood name is persisted. Overridable for testing.
MOODS_STATE="${MOODS_STATE:-$HOME/.claude/moods-active}"

# Read the active mood name; default to "doge". Falls back if the theme dir is gone.
active_mood() {
  local m="doge"
  [ -f "$MOODS_STATE" ] && m=$(tr -d '[:space:]' < "$MOODS_STATE")
  [ -d "$MOODS_ROOT/themes/$m" ] || m="doge"
  printf '%s' "$m"
}

# theme_field <mood> <json-key>  — read a scalar from theme.json (jq, no deps beyond jq).
theme_field() {
  local mood="$1" key="$2" f="$MOODS_ROOT/themes/$1/theme.json"
  [ -f "$f" ] || return 1
  jq -r --arg k "$key" '.[$k] // empty' "$f" 2>/dev/null
}

# theme_words <mood> — space-separated intensifier words.
theme_words() {
  local f="$MOODS_ROOT/themes/$1/theme.json"
  [ -f "$f" ] && jq -r '.words // [] | join(" ")' "$f" 2>/dev/null
}

# theme_color <mood> <primary|accent|ok> — 256-color code, with doge-ish fallbacks.
theme_color() {
  local f="$MOODS_ROOT/themes/$1/theme.json" key="$2" def
  case "$key" in primary) def=220;; accent) def=213;; ok) def=114;; *) def=245;; esac
  if [ -f "$f" ]; then
    jq -r --arg k "$key" ".colors[\$k] // $def" "$f" 2>/dev/null || printf '%s' "$def"
  else
    printf '%s' "$def"
  fi
}
