---
name: recap
description: Print an in-character recap of the current session in the active mood's voice, with that mood's ASCII art. Use when the user types /recap, /moods:recap, or asks for a mood/doge/pirate/etc. session recap, summary, or "how'd we do". Does NOT change the mood — it recaps in whatever mood is already active.
---

# /recap — session recap, in the active mood's voice

Print a recap of THIS session in whatever mood is currently active. This does **not**
switch moods — it reads the active mood and speaks in that voice. (To change mood, use
`/mood <name>`.)

## Steps

1. Resolve the active mood: read `~/.claude/moods-active` (trim whitespace). If missing or
   its `${CLAUDE_PLUGIN_ROOT}/themes/<mood>/` folder doesn't exist, fall back to `doge`.

2. **The art.** Print `${CLAUDE_PLUGIN_ROOT}/themes/<mood>/art.txt` verbatim inside a code
   fence so it renders monospaced.

3. **The recap, in character.** Summarize what actually happened in THIS session, grounded
   in real transcript events — do not invent. A short bullet list (~4–8 bullets), each an
   honest fact wrapped in the mood's voice, using that theme's `words` (from `theme.json`)
   as intensifiers. Cover when applicable: the goal, what got built/changed/fixed (name
   real files/commands), what's open/next, any blocker. Close with the theme's `signoff`
   line from `theme.json`.

## Style rules
- Flavor the PROSE, not the FACTS. File paths, commands, numbers, and identifiers stay
  literal and correct inside backticks — in every mood.
- Be truthful. Quiet session? Say so, in character.
- Read the room: if the user is debugging something serious or frustrated, dial the
  character WAY down.
- One recap. No extra preamble.
