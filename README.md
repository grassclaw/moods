# 🎭 moods

> Give your Claude Code session a personality. `/mood caveman` and everything speaks caveman.

A joke-but-functional Claude Code plugin. Pick a **mood** and a single switch drives three
surfaces at once — the prose, the statusline, and the after-turn one-liner — all in
character. Ships with four moods; adding your own is dropping a folder.

| Mood | Voice |
|------|-------|
| 🐕 **doge** | such fix. very green. wow. |
| 🪨 **caveman** | ME FIX BUG. BUG DEAD. FIRE GOOD. |
| 🏴‍☠️ **pirate** | Arr, the scurvy null check be run to ground, matey. |
| 🎭 **shakespeare** | Lo, the null check is mended; the suite doth pass. |

## What it drives

| Component | What it does |
|-----------|--------------|
| **`/mood <name>`** | The switch. Persists the active mood and flips everything to it. |
| **Statusline** | `🐕 such Opus · wow 8% ctx · very high · much $0.01` — real session info wrapped in the active mood's words + palette. |
| **Output styles** | One per mood. Makes Claude's *prose* talk in character while keeping all code, paths, and commands 100% literal and correct. |
| **Stop hook** | Drops a random in-character one-liner each time a turn finishes. |
| **`/mood`** (no arg) | Prints the mood's ASCII art + an honest, in-character recap of the session. |

## Install (local / dev)

```bash
# one-off, this session only (use wherever you cloned it):
claude --plugin-dir ~/Development/moods

# then inside Claude Code:
/mood                       # picker of available moods (or a session recap)
/mood pirate                # switch mood directly (persists across sessions)
/moods:setup-statusline     # wire the statusline into your settings
```

The Stop hook activates automatically once the plugin is loaded. Switching a mood flips
the statusline and hook **immediately**, and writes the matching `outputStyle` into
`~/.claude/settings.json` for you — but the **prose** style only takes effect after a
`/clear` or a new session (Claude Code reads the output style once at startup).

### Persistent install

Point a marketplace at this repo (git-hosted; no `file://` marketplaces supported), or
copy the dir under `~/.claude/skills/` to auto-load it every session.

## Add your own mood

No code changes. Drop a folder under `themes/<name>/` with three files:

```
themes/<name>/
├── theme.json      # emoji, outputStyle name, words[], colors{primary,accent,ok}, signoff
├── art.txt         # ASCII art for /mood recap
└── one-liners.txt  # one per line; Stop hook picks at random
```

Then add a matching `output-styles/<OutputStyle>.md` for the prose voice, and `/mood <name>`
just works. See `themes/doge/` as the reference.

## How it works

`~/.claude/moods-active` holds the active mood name — the single source of truth. `/mood`
writes it; the statusline and Stop-hook scripts (`scripts/statusline.sh`, `scripts/stop.sh`,
via `scripts/lib.sh`) read it and render the matching theme pack. Defaults to `doge` if
unset or missing.

## Why not the spinner words?

The original idea was to theme the *thinking words* (the "Cogitating…" spinner verbs).
Those are **hardcoded** in Claude Code — no setting, env var, or hook exposes them. So
`moods` hits everything that *is* customizable instead.

## Requirements

- `jq` on PATH (statusline + theme reading depend on it).

## Structure

```
moods/
├── .claude-plugin/plugin.json   # manifest
├── themes/<name>/               # theme packs (theme.json, art.txt, one-liners.txt)
├── output-styles/*.md           # one prose style per mood
├── hooks/hooks.json             # Stop hook wiring
├── scripts/
│   ├── lib.sh                   # resolves the active mood + theme fields
│   ├── statusline.sh            # renders the status line
│   └── stop.sh                  # emits the after-turn one-liner
└── skills/
    ├── mood/                    # /mood switch + recap
    └── setup-statusline/        # installs the statusline into user settings
```

much plugin. very personality. wow.
