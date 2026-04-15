---
name: snapshot
description: Write back all in-session state to canon docs. Run before ending a session, before context compaction, or at any natural breakpoint. Prevents design decisions from living only in conversation history.
---

> **Adapt this:** Replace the doc paths and checklist items with your project's actual canon docs. The pattern is: session-recovery doc first (Now.md), active living doc second (the most common failure point), append-only logs third, then everything else.
>
> **Pair with:** `stop-snapshot-reminder.sh` hook for deterministic enforcement — the hook fires when Claude is about to stop and injects a reminder to check for unwritten design decisions. The skill handles the full write-back; the hook ensures it's never forgotten.
>
> **Supersedes:** The older `claude-commands/snapshot.md` command format. Skills are the current Claude Code mechanism.

# Snapshot — Write Back All Context to Docs

The user is at risk of context compaction or ending a session. **Immediately write back all in-session state to canon docs.**

Do NOT ask questions. Do NOT do any other work first. Write back now.

## Write-Back Checklist

For each file, compare what's in the doc vs what's true in the current conversation. Update anything that's stale.

### 1. `Docs/Now.md` (HIGHEST PRIORITY)
- What are we working on right now?
- Current state — what's been done, what's next
- Parked items — any new ones from this session?
- Active system — still correct?

### 2. Active Living Doc (identified in Now.md)
- Were any design decisions made this session that aren't reflected in the living doc?
- Did the architecture, flow, or constraints change?
- Were any open questions resolved? Add to Resolved section.
- Were any new open questions raised? Add to Open Questions table.
- **This is the most common failure point.** Design conversations produce settled answers that never land here.

### 3. `Docs/Decisions.md` (append-only, tail-read to find next number)
- Were any design decisions made this session that don't have a D-NNN entry yet?
- If yes, add them now. Use the next number in sequence.
- Only read the last 20 lines to find the current number. Do not read the full file.

### 4. `MEMORY.md` (minimal — factual reference only)
- Did any settled architecture facts change?
- Add or update entries only for facts that need to be in context every session.
- Remove anything that's now captured in a living doc and doesn't need per-session loading.

### 5. Technical Design Doc (e.g. `Docs/TDD.md`, if deliverables changed)
- Did any deliverable status change?
- Did any data model types change?
- Only update if implementation work was done this session.

### 6. Other living docs (only if touched this session)
- Only check docs that are relevant to this session's work.

## Output

After updating, print a short summary:
```
Snapshot complete. Updated:
- Now.md: [what changed]
- [Living doc]: [what changed]
- Decisions.md: [D-NNN added / no changes]
- MEMORY.md: [what changed / no changes]
- TDD.md: [what changed / no changes]

Safe to compact or end session.
```

## Rules

- Be fast. The user may be running out of context.
- Don't add speculative content — only write back what was actually decided or built.
- If nothing changed for a file, skip it and note "no changes needed."
- Don't read entire Decisions.md — tail-read only.
- Commit nothing — just update the docs. The user will commit when ready.

## Why This Skill Exists

Design decisions made in conversation get lost when sessions end or context compacts. The living doc is the source of truth, but updating it is a process gate — and process gates fail silently in agentic mode (see `learnings/process-gates-agentic-workflows.md`). This skill converts the write-back into an explicit, invocable action. Pair with the `stop-snapshot-reminder.sh` hook for deterministic enforcement.
