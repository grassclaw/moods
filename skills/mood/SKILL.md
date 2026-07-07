---
name: mood
description: Switch the session's personality mood (doge, caveman, pirate, shakespeare) or get an in-character session recap. Use when the user types /mood, /mood <name>, or asks to change/switch the vibe, personality, or theme, or asks for an in-character session summary/recap.
---

# /mood — one switch. every surface. in character.

`moods` gives your Claude Code session a personality. A single active mood drives three
surfaces at once: the **prose** (output style), the **statusline** flavor, and the
**Stop-hook** one-liner. This skill is how you switch it and how you get a recap.

Available moods live in `${CLAUDE_PLUGIN_ROOT}/themes/` — each is a folder with
`theme.json`, `art.txt`, and `one-liners.txt`. Read that directory to discover them;
do not hardcode the list. As shipped: **doge, caveman, pirate, shakespeare**.

## Mode A — `/mood <name>` (switch)

When the user names a mood (e.g. `/mood caveman`):

1. Verify `${CLAUDE_PLUGIN_ROOT}/themes/<name>/` exists. If not, list the available
   theme folders and stop.
2. Persist the choice: write the bare mood name (no newline fuss) to `~/.claude/moods-active`.
   This is the single source of truth the statusline + Stop hook both read.
   ```bash
   printf '%s' "<name>" > ~/.claude/moods-active
   ```
3. Switch the prose style to match. Read `outputStyle` from
   `${CLAUDE_PLUGIN_ROOT}/themes/<name>/theme.json` and tell the user to run
   `/output-style <that value>` (the harness can't change output style programmatically —
   it's a user action). The statusline and Stop-hook flip **immediately** on the next
   render; only the prose needs that one manual command.
4. Confirm in one line, already speaking in the new mood's voice.

## Mode B — `/mood` alone, or `/mood <name>` recap request (summary)

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
