# 🐕 doge-code

> much plugin. very Claude Code. wow.

A joke-but-functional Claude Code plugin that doge-ifies your session. Bundles three things:

| Component | What it does |
|-----------|--------------|
| **Statusline** | `🐕 such Opus · wow 8% ctx · very high · much $0.01` — real session info wrapped in cycling doge intensifiers, with doge-gold/shibe-magenta coloring that shifts as context fills. |
| **Output style** (`Doge`) | Makes Claude's *prose* talk doge ("such fix. very green. wow.") while keeping all code, paths, and commands 100% literal and correct. |
| **Stop hook** | Drops a random doge one-liner ("wow. very done. much answer.") each time a turn finishes. |

## Why not the spinner words?

The original idea was to doge-ify the *thinking words* (the "Cogitating…" spinner verbs).
Those are **hardcoded** in Claude Code — no setting, env var, or hook exposes them. much sad.
So doge-code hits everything that *is* customizable instead.

## Install (local / dev)

```bash
# one-off, this session only:
claude --plugin-dir ~/Development/doge-code

# then inside Claude Code:
/output-style Doge            # turn on doge prose
/doge-code:setup-statusline   # wire the statusline into your settings
```

The Stop hook activates automatically once the plugin is loaded.

### Persistent install

Point a marketplace at this repo (git-hosted; no `file://` marketplaces supported), or copy
the dir under `~/.claude/skills/` to auto-load it every session.

## Requirements

- `jq` on PATH (statusline dependency).

## Structure

```
doge-code/
├── .claude-plugin/plugin.json     # manifest
├── output-styles/doge.md          # the "Doge" output style
├── hooks/hooks.json               # Stop hook wiring
├── scripts/
│   ├── doge-statusline.sh         # renders the status line
│   └── doge-stop.sh               # emits the doge one-liner
└── skills/setup-statusline/       # installs the statusline into user settings
```

wow. such plugin. very done.
