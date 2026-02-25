# Technical Design Document Template

> Copy this to your project as `Docs/TDD.md` and adapt.
> Everything in `[BRACKETS]` needs to be replaced with your project's specifics.

---

```markdown
# [PROJECT_NAME] — Technical Design Document

## 1. Purpose

[One paragraph: what the game is, its architecture, and its current phase. Link to SettledDesign.md for detailed design.]

## 2. Architecture

### Design Principles

- [e.g. Data-driven design — galaxy, races, tech trees defined as data, not hardcoded]
- [e.g. Deterministic game logic — same inputs produce same outputs]
- [e.g. LLM integration as a boundary module — isolated behind interfaces]

### Key Subsystems

| Subsystem | Layer | Description | Status |
|-----------|-------|-------------|--------|
| [Game State Model] | [Core] | [Entity definitions, serialization] | [Not started] |
| [Turn Resolution] | [Core] | [Order processing, deterministic resolution] | [Not started] |
| [Economy] | [Core] | [Resource production, allocation] | [Not started] |
| [Session Management] | [Server] | [Game hosting, player connections] | [Not started] |
| [Map Renderer] | [Client] | [Visual representation] | [Not started] |

> **Adapt this:** The Layer column depends on your architecture. A single-layer game might omit it. A client-server game needs Core/Server/Client. The subsystems are game-specific.

### Data Model

| Type | Purpose |
|------|---------|
| [GameState] | [Top-level state container] |
| [Entity] | [Individual game entity: position, owner, stats] |
| [Player] | [Player definition: personality, owned entities, resources] |

> **Adapt this:** List your canonical data types. These are the types that SettledDesign.md's terminology section references. Keep this aligned.

## 3. Constraints

[Non-negotiable technical rules. Grouped by layer if multi-layer.]

### [Core / Shared]
- [e.g. No framework dependencies — pure language, standard library only]
- [e.g. Deterministic — same inputs produce same outputs. Seeded RNG only.]
- [e.g. Serializable state — all game state must round-trip through serialization]

### [Client]
- [e.g. No simulation authority — client displays state and captures input]
- [e.g. No expensive operations in hot paths — cache, pool, pre-allocate]

### [Server]
- [e.g. Authoritative — server is single source of truth for game state]
- [e.g. LLM calls behind interfaces — swappable mock/real implementations]

## 4. Deliverables

Each deliverable has acceptance criteria and an implementation plan:
- `Docs/deliverables/D{N}-acceptance.md` — what "done" looks like
- `Docs/deliverables/D{N}-plan.md` — implementation steps, team assignments, validation

### [Milestone 1: Name] — [Status]

Goal: [What this milestone proves or delivers]

| Deliverable | Status |
|------------|--------|
| [D-001: Name] | [Not started / In progress / Complete] |
| [D-002: Name] | [Not started] |

### [Milestone 2: Name] — [Status]

Goal: [TBD or description]

## 5. [Optional: Prototype / Reference]

[If you have a prototype or reference implementation, describe it here. Keep it clearly separated from the game architecture.]
```

---

> **Adapt this:** The architecture section scales from simple (single project, no layers) to complex (multi-project, client-server-core). The deliverable tracking pattern (D{N} files in `Docs/deliverables/`) is the reusable structure. The subsystems, constraints, and milestones are all game-specific.
