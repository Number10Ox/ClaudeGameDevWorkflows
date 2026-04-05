---
name: session-start
description: "Run at the beginning of every session to load project context. Reads Now.md, active system docs, and naming conventions."
user-invocable: false
---

> **Adapt this:** Replace the file paths with your project's actual context docs. Add or remove reads based on what you need loaded every session. Keep this lean — every file read here costs tokens on every session start.

# Session Start

Loads essential project context at the beginning of every session.

## On Invocation

Read these files in order:

1. `Docs/Now.md` — current state snapshot (what's active, what's next)
2. The living doc named in Now.md — current system's full context
3. Your project's naming guide or conventions doc (if applicable)

## Why This Exists

Session start reads in CLAUDE.md ("Read Now.md at session start") are process gates — they work in chat but fail silently in agentic mode. This skill converts the session start sequence into a mechanical code path that executes reliably.

## Notes

- Keep the read list minimal. Every file here loads on every session.
- `Docs/Roadmap.md` is intentionally NOT loaded here — only needed when scoping new work.
- If you need conditional reads (e.g., "read the UI spec only if doing UI work"), those belong in domain-specific skills, not here.
