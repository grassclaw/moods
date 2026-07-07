---
name: mood
description: Switch the session's personality mood (doge, caveman, pirate, shakespeare) or get an in-character session recap. Use when the user types /mood, /mood <name>, or asks to change/switch the vibe, personality, or theme, or asks for an in-character session summary/recap. With no mood named, shows a selectable picker of the available moods.
---

# /mood — one switch. every surface. in character.

`moods` gives your Claude Code session a personality. A single active mood drives three
surfaces at once: the **prose** (output style), the **statusline** flavor, and the
**Stop-hook** one-liner. This skill is how you switch it and how you get a recap.

Available moods live in `${CLAUDE_PLUGIN_ROOT}/themes/` — each is a folder with
`theme.json`, `art.txt`, and `one-liners.txt`. Read that directory to discover them;
do not hardcode the list. As shipped: **doge, caveman, pirate, shakespeare**.

## Routing — decide which mode

- Invoked **with a mood name** (`/mood caveman`) → **Mode A** (switch directly).
- Invoked **with no argument** (`/mood`) → **show the picker** (below), then act on the choice.
- Invoked with a word like "recap", "summary", or "how'd we do" → **Mode B** (recap).

### The picker (no-argument invocation)

Do NOT default to a recap when no mood is named. Call the `AskUserQuestion` tool
**directly** — single-select, header `Mood` — with the options listed below. Do NOT run
any shell commands or read any files to build it; the options are baked in here so the
picker is instant. Question text: "Which mood? (or choose Other and type a mood name, or
`recap`.)"

Options (label · description):
- **Doge** — such code. very ship. much wow. so productive.
- **Caveman** — CODE GOOD. FIRE HOT. Short blunt all-caps grunts. UNGA BUNGA SHIP.
- **Pirate** — Arr, ye scurvy code! Hearty commits, briny bugfixes. Ship it, landlubbers.
- **Shakespeare** — Hark! Most noble code, fair and wondrous. Prithee, ship we must.

**Constraint: `AskUserQuestion` allows at most 4 options** — that's exactly the 4 above,
so there's no room for a dedicated "Recap" option. Recap is reachable via the tool's
built-in "Other" field (type `recap`). If more than 4 themes ever ship, list only 4 here
and note in the question text that others can be named directly (`/mood <name>`).

After the user answers:
- Picked a mood, or typed a valid mood name in Other → do **Mode A** for it.
- Typed `recap` (or similar) in Other → do **Mode B** for the currently active mood.
- Typed an unknown word → list the available themes (`${CLAUDE_PLUGIN_ROOT}/themes/`) and stop.

> Keeping the list above in sync: when you add a theme folder, add one bullet here too.
> This is the ONE place the picker is hardcoded — everything else stays dynamic.

## Mode A — switch to a named mood

When a mood is chosen (via argument or the picker):

1. Verify `${CLAUDE_PLUGIN_ROOT}/themes/<name>/` exists. If not, list the available
   theme folders and stop.
2. Persist the choice: write the bare mood name (no newline fuss) to `~/.claude/moods-active`.
   This is the single source of truth the statusline + Stop hook both read.
   ```bash
   printf '%s' "<name>" > ~/.claude/moods-active
   ```
3. Switch the prose style to match by writing the `outputStyle` key into the user's
   settings — do NOT tell the user to run `/output-style` (that command was removed from
   Claude Code; it no longer exists). Read `outputStyle` from
   `${CLAUDE_PLUGIN_ROOT}/themes/<name>/theme.json` (e.g. `Doge`), then merge it into
   `~/.claude/settings.json` **without clobbering** other keys — parse the JSON, set the
   one key, write it back. If the file doesn't exist, create it as `{ "outputStyle": "<value>" }`.
   ```bash
   f="$HOME/.claude/settings.json"
   [ -f "$f" ] || echo '{}' > "$f"
   tmp=$(jq --arg v "<OutputStyleValue>" '.outputStyle = $v' "$f") && printf '%s\n' "$tmp" > "$f"
   ```
4. Tell the user the statusline and Stop-hook flipped **immediately**, but the prose style
   only takes effect after a **`/clear` or a new session** (Claude Code reads the output
   style once at session start). So: `/clear` to get the new voice now.
5. Confirm in one line, already speaking in the new mood's voice.

## Mode B — recap (picker "Recap" choice, or an explicit recap request)

Produce an in-character session recap. Two parts, in order:

### 1. The art
Print `${CLAUDE_PLUGIN_ROOT}/themes/<active-mood>/art.txt` verbatim inside a code fence
so it renders monospaced. (Active mood = contents of `~/.claude/moods-active`, else `doge`.)

### 2. The recap (in character)
Summarize what actually happened in THIS session, grounded in real transcript events —
do not invent. A short bullet list, each an honest fact wrapped in the mood's voice, using
that theme's `words` as intensifiers. Cover when applicable: the goal, what got
built/changed/fixed (name real files/commands), what's open/next, any blocker. ~4–8 bullets.
Close with the theme's `signoff` line from `theme.json`.

## Style rules (all modes)
- Flavor the PROSE, not the FACTS. File paths, commands, numbers, identifiers stay literal
  and correct inside backticks — in every mood.
- Be truthful. Quiet session? Say so, in character.
- Read the room: if the user is debugging something serious or frustrated, dial the
  character WAY down and just help.
- One switch or one recap. No extra preamble.
