# Snapshot — Write Back All Context to Docs

> **Superseded by:** `templates/skills/snapshot/SKILL.md` — the skill format is the current Claude Code mechanism and includes living doc checks and a companion Stop hook for deterministic enforcement. This command format is kept for reference.
>
> Copy this to your project as `.claude/commands/snapshot.md`.
> Adapt the checklist to match your project's canon docs.

---

```markdown
# Snapshot — Write Back All Context to Docs

The user is at risk of context compaction or ending a session. **Immediately write back all in-session state to canon docs.**

Do NOT ask questions. Do NOT do any other work first. Write back now.

## Write-Back Checklist

For each file, compare what's in the doc vs what's true in the current conversation. Update anything that's stale.

### 1. `Docs/Now.md` (HIGHEST PRIORITY)
- Active Question — what are we working on right now?
- Mode — DESIGN or EXECUTION?
- Current State — bullet list of what's been done this session
- Open Questions — any resolved? any new ones?
- Maturity — has the prototype changed?

### 2. `Docs/Decisions.md` (append-only)
- Were any design decisions made this session that don't have a D-NNN entry yet?
- If yes, add them now. Use the next number in sequence.

### 3. `Docs/SettledDesign.md`
- Did any settled design elements change?
- Did architecture status change?
- Did terminology change?

### 4. `Docs/GamePillars.md`
- Did any core pillars or mechanics descriptions change?
- (Usually stable — only update if design fundamentals shifted)

### 5. [Technical Design Doc] (e.g. `Docs/TDD.md`)
- Did any data model types change?
- Did architecture or constraints change?

## Output

After updating, print a short summary:

Snapshot complete. Updated:
- Now.md: [what changed]
- Decisions.md: [D-NNN added / no changes]
- SettledDesign.md: [what changed / no changes]
- etc.

Safe to compact or end session.

## Rules

- Be fast. The user is running out of context.
- Don't add speculative content — only write back what was actually decided or built.
- If nothing changed for a file, skip it and note "no changes needed."
- Commit nothing — just update the docs. The user will commit when ready.
```

---

> **Adapt this:** Replace the doc paths and checklist items with your project's actual canon docs. The pattern is: highest-priority session-recovery doc first, append-only logs second, then everything else.
