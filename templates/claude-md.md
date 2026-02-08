# .claude/CLAUDE.md Template

> Copy this to your project as `.claude/CLAUDE.md` and adapt.
> Everything in `[BRACKETS]` needs to be replaced with your project's specifics.

---

```markdown
# Claude Code Rules

## Project

**[PROJECT_NAME]** — [one-line description of the game and its current phase].

## Session Start

At the start of each session, read:
- `Docs/Now.md` — active question, mode, layer, current state, non-goals
- `Docs/SettledDesign.md` — current game design, mechanics, terms, invariants (the source of truth)
- `Docs/GamePillars.md` — game design pillars and core loop

Reference as needed:
- `Docs/Decisions.md` — chronological decision log with rationale and deprecated terms
- `Docs/workflow-design.md` — game design process (DESIGN mode)
- `Docs/workflow-engineering.md` — engineering process (EXECUTION mode)

## Design vs Execution Mode

Check `Docs/Now.md` for the current mode:
- **DESIGN mode** — follow `Docs/workflow-design.md`: layer declaration, one active question, write-back to Decisions.md
- **EXECUTION mode** — follow `Docs/workflow-engineering.md`: plan, implement, verify, sign off

## Tech Stack

- [Language and version, e.g. TypeScript (strict mode)]
- [Runtime, e.g. Node.js (ESM modules)]
- [Test framework, e.g. Vitest]
- [Other key dependencies]

## Coding Style

### Naming
- Files: [your convention, e.g. PascalCase for types, camelCase for scripts]
- Types/Interfaces: [e.g. PascalCase]
- Functions: [e.g. camelCase]
- Constants: [e.g. UPPER_SNAKE_CASE]

### Code Organization
- `src/model/` — [description, e.g. Pure data types, no logic]
- `src/engine/` — [description, e.g. Game logic as pure functions]
- `src/[other]/` — [description]
- `tests/` — [description, e.g. Mirrors src/ structure]

### Principles
- [e.g. Engine functions are pure — same input always produces same output]
- [e.g. No classes for game logic — use functions + interfaces]
- [e.g. All game state is immutable — mutations return new objects]
- [e.g. No `any` types. Use `unknown` + type guards if needed.]

## Testing

- Test file naming: `[ModuleName].test.ts`
- Test method naming: `describe("functionName")` / `it("should do X when Y")`
- [e.g. All engine functions must have tests]
- [e.g. Use deterministic seeds for any randomness in tests]

## Source of Truth

- The committed codebase + design docs are the only source of truth
- Do NOT retrieve or reuse old code from git history unless explicitly asked
- If something seems missing, create a "Missing Inventory" list and propose new solutions
- If older ideas are found, quarantine them as "Candidate re-adoptions (NOT ACTIVE)"

## Game Design Constraints

> **Adapt this:** These are your non-negotiable game design rules. Examples below.

- [e.g. No LLM-judged outcomes — scoring is always deterministic]
- [e.g. Agent output is schema-constrained JSON, never free-form prose]
- [e.g. Every score breakdown must be visible and auditable]
```

---

> **Adapt this:** The session start docs, tech stack, folder structure, and constraints are all project-specific. The *structure* of this file (sections, session start protocol, mode switching, source of truth rules) is the reusable pattern.
