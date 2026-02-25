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

## Deliverable Workflow

Each deliverable gets two files in `Docs/deliverables/`:
- `D{N}-acceptance.md` — acceptance criteria (written during planning)
- `D{N}-plan.md` — implementation plan (written by `/plan_with_team` or manually)

### Agent Team

- **Builder** (`.claude/agents/team/builder.md`) — implements code + tests. All implementation goes through builders.
- **Validator** (`.claude/agents/team/validator.md`) — read-only verification. Inspects, runs tests, reports PASS/FAIL. Never modifies files.

Typical per-task flow: Builder implements → Validator verifies → fix if needed → re-verify.

### Orchestration

Use `/plan_with_team` to plan and orchestrate deliverable execution with builder/validator agents.

## Testing

- Test file naming: `[ModuleName].test.ts`
- Test method naming: `describe("functionName")` / `it("should do X when Y")`
- [e.g. All engine functions must have tests]
- [e.g. Use deterministic seeds for any randomness in tests]

### Sacred Contract Tests

Each major subsystem gets 3-5 identity tests that define "what this system IS." These tests:
- Never break (if they break, the system's identity has changed)
- Are written first, before implementation details
- Serve as living documentation of core invariants
- [e.g. "Core loop completes: boot → meaningful choice → consequence → debrief"]

> **Adapt this:** Sacred contract tests are game-specific. Examples: "dungeon generates a valid path," "relationship value equals sum of active modifiers," "resolution is deterministic under all seeds."

## Source of Truth

- The committed codebase + design docs are the only source of truth
- Do NOT retrieve or reuse old code from git history unless explicitly asked
- If something seems missing, create a "Missing Inventory" list and propose new solutions
- If older ideas are found, quarantine them as "Candidate re-adoptions (NOT ACTIVE)"

## Write-Back Before Session End or Context Risk

Context compaction loses in-session details. To survive it, **write back to docs before losing context**:

1. **After every significant change** (new decision, prototype update, design resolution):
   - Update `Docs/Now.md` current state to reflect what just happened
   - Add a `Docs/Decisions.md` entry if a decision was made (D-NNN format)
   - Update relevant technical/design docs if types, architecture, or settled elements changed

2. **When the user mentions compaction risk** (e.g., "99% context", "running out of context"):
   - Immediately write back ALL pending state to docs before doing anything else
   - Prioritize Now.md (it's the session-start file) and Decisions.md (append-only, never loses history)

3. **Rule: docs must always be current enough that a fresh session reading only the Session Start files can pick up where we left off.** If something is only in conversation context and not in a doc, it's at risk.

4. **Proactive context management:** Your context window will be automatically compacted as it approaches its limit, allowing you to continue working indefinitely. Do not stop tasks early due to context budget concerns. As you approach the context limit, proactively write back all pending state to docs before the window refreshes. Always complete tasks fully rather than stopping early.

## Game Design Constraints

> **Adapt this:** These are your non-negotiable game design rules. Examples below.

- [e.g. No LLM-judged outcomes — scoring is always deterministic]
- [e.g. Agent output is schema-constrained JSON, never free-form prose]
- [e.g. Every score breakdown must be visible and auditable]
```

---

> **Adapt this:** The session start docs, tech stack, folder structure, and constraints are all project-specific. The *structure* of this file (sections, session start protocol, mode switching, source of truth rules) is the reusable pattern.
