---
name: setup-statusline
description: Wire the moods statusline into the user's Claude Code settings. Use when the user wants to enable, install, or turn on the mood-aware statusline (the "🐕 such Opus · wow 8% ctx" style line that follows the active mood).
---

# Install the moods statusline

The statusline script ships inside this plugin, but Claude Code does not let a plugin
register a `statusLine` on its own — that key only works in user/project settings. This
skill wires it up in one shot. Once installed, the statusline automatically follows
whatever mood is active (set via `/mood <name>`).

## Steps

1. Resolve the absolute path to the bundled script. It lives at
   `${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh`. Expand `${CLAUDE_PLUGIN_ROOT}` to its
   real absolute value (run `echo "${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh"` in Bash) —
   user settings need a literal path, not the variable.

2. Confirm the script is executable: `chmod +x "<resolved-path>"`.

3. Read the target settings file. Prefer project scope if the user is in a repo and asks
   for project-level; otherwise use user scope `~/.claude/settings.json`. Ask which scope
   if ambiguous.

4. Merge (do NOT overwrite the whole file) this key into that settings JSON, using the
   resolved absolute path:

   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "<resolved-absolute-path>/statusline.sh",
       "padding": 1,
       "refreshInterval": 5
     }
   }
   ```

   If a `statusLine` already exists, show the user the current value first and confirm
   before replacing it. Preserve all other keys in the file (parse, set one key, write
   back — never clobber).

5. Tell the user it takes effect on the next status refresh (after the next assistant
   message) — no restart needed. To remove it later, delete the `statusLine` key.

## Notes
- The script needs `jq` on PATH (hard dependency, for reading session JSON + theme files).
  Check with `which jq` and warn if missing.
- The line reflects the active mood from `~/.claude/moods-active` (defaults to `doge`).
