---
name: session-start
description: "SUPERSEDED by session-start hook. Use the hook instead."
user-invocable: false
---

# Session Start (Superseded)

**This skill is superseded by the `session-start.sh` hook.** Use `templates/claude-hooks/session-start.sh` instead.

## Why

This skill required the model to decide to invoke it at session start — which is itself a process gate. The model would read "invoke session-start skill" in CLAUDE.md and then skip it, exactly like it skipped "read Now.md at session start." The hook fires automatically before the model generates anything, with no decision required.

See `learnings/process-gates-agentic-workflows.md` for the full explanation.
