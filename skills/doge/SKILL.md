---
name: doge
description: Summon the doge. Renders ASCII doge art and recaps the current session in doge-speak. Use when the user types /doge or asks for a doge session summary / recap / "how'd we do".
---

# /doge — such summary. very session. wow.

When invoked, produce a session recap in the voice of doge. Output has two parts, in order:

## 1. The doge

Print this ASCII doge verbatim inside a code fence so it renders monospaced:

```
                ▄              ▄
               ▌▒█           ▄▀▒▌
               ▌▒▒█        ▄▀▒▒▒▐
              ▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐
            ▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐
          ▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌
         ▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌
         ▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐
        ▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌
        ▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌
       ▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐
       ▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌
       ▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐
        ▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌
        ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐
         ▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌
           ▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀
             ▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀
                ▒▒▒▒▒▒▒▒▒▒▀▀
```

Below the art, print a title line: **wow. such session. very recap.**

## 2. The recap (in doge)

Summarize what actually happened in THIS conversation/session so far. Ground every point
in real events from the transcript — do not invent. Format as a short doge bullet list,
each bullet an honest fact wrapped in doge-speak. Use the doge modifiers "such / very /
much / so / many / wow" in front of nouns.

Cover, when applicable:
- what the user set out to do (**such goal**)
- what got built / changed / fixed (**very work**) — name real files/commands
- what's still open or next (**much todo**)
- any blocker or gotcha hit (**concern.**)

Keep it to ~4–8 bullets. Close with a single doge sign-off line (e.g. "very productive.
much wow. so ship.").

### Style rules
- Doge-ify the prose, NOT the facts: file paths, commands, numbers, and identifiers stay
  literal and correct inside backticks.
- Be truthful. If little happened, say so ("very quiet session. such calm.").
- If the user asked `/doge <topic>`, focus the recap on that topic.
- One doge. one recap. no extra preamble.

## Example output shape

```
[ascii doge]
```
**wow. such session. very recap.**

- 🐕 **such goal** — you wanted a doge session-summary skill
- 🐕 **very work** — built `skills/doge/SKILL.md`, tested the plugin load
- 🐕 **much todo** — still need to `/reload-plugins` and try `/doge` live
- 🐕 concern. `/output-style` is deprecated, use `/config` now

very productive. much wow. so ship.
