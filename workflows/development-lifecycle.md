# Development Lifecycle

How milestones, deliverables, and plans connect. This is the top-level workflow that ties [design-mode.md](design-mode.md) and [execution-mode.md](execution-mode.md) together.

Read this at session start alongside Now.md to know where you are.

---

## Hierarchy

```
Milestone (TDD.md §4)
  └── Deliverable (DEL-XXX in TDD.md)
        └── Plan (process/plan-del-XXX-name.md)
              ├── Docs in scope (listed in the plan)
              ├── Design steps (DESIGN mode → design docs, living docs)
              └── Implementation steps (EXECUTION mode → code, tests)
```

- A **milestone** is a playable state. It has a goal and deliverables. Defined in TDD.md and Roadmap.md.
- A **deliverable** is a verifiable result tracked in TDD.md with a DEL number. It has acceptance criteria and a plan. Prefer deliverables that are user-facing and playable. When a result isn't independently playable but has its own ACs and meaningful scope, it can be a deliverable — but the milestone it belongs to must produce something playable.
- A **plan** lives at `process/plan-del-XXX-name.md`. It lists docs in scope, steps, and acceptance criteria. Design work (specs, living doc updates) and engineering work (code, tests) are both steps within a plan.
- **Design docs** (specs, design explorations) are steps within a deliverable's plan, not standalone deliverables.

---

## Master Docs

| Doc | Owns | Updated when |
|---|---|---|
| **TDD.md** | Milestones, deliverables, architecture, constraints | New milestone, new deliverable, deliverable completes |
| **GDD.md** | Game identity, pillars, theses, player experience | Design decisions that change the game's identity |
| **Roadmap.md** | Current + next milestone (high level) | Milestone closes or scope changes |
| **Now.md** | Active deliverable, mode, next steps | Every session start and end |
| **Living docs** | Per-system current reality | After implementation changes a system |
| **Decisions.md** | Chronological decision log | Design decisions made |

**Chain of reference:** Now.md → current deliverable's plan → TDD.md milestone → Roadmap.md goal.

---

## Session Start

1. Read **Now.md** — what's active, what mode, what deliverable, what's next.
2. Read the **current deliverable's plan** (named in Now.md) — docs in scope, where you left off.
3. Read the **workflow doc for the current mode** — [design-mode.md](design-mode.md) or [execution-mode.md](execution-mode.md). This is how multi-day derailments happen: the mode practices exist but don't get loaded.
4. Read the **living doc** for the active system (named in Now.md) — current system reality.

If Now.md doesn't name a deliverable and plan, that's a problem. Fix it before doing work.

---

## Mode Entry Gate

Before starting any step, confirm you're in the right mode.

**Before starting a DESIGN step:** Is there a design question to resolve? Is the output a spec, living doc update, or design decision? If you're about to write code, you're in the wrong mode.

**Before starting an EXECUTION step:** Does the design artifact this step implements against exist? Has it been read this session? If the answer to either is no, stop. Read the artifact first, or return to a design step to create it. This is the gate that catches miscategorized tasks — writing code "against" a spec you haven't read is not execution, it's improvisation.

---

## Milestone Lifecycle

1. **Define** — goal, playable state at completion, required systems. Write in TDD.md and Roadmap.md.
2. **Scope deliverables** — each deliverable is a verifiable result. Add to TDD.md with DEL numbers.
3. **Execute deliverables** — one at a time. Plan, design, build, verify. Mark complete in TDD.md.
4. **Close** — all deliverables done (or explicitly deferred). Update TDD.md status, compress Roadmap.md, update Now.md.

**When to create a new milestone:** When the current work no longer fits the current milestone's goal. Don't add unrelated deliverables to an existing milestone — create a new one. Move deferred deliverables explicitly.

**Don't start a new milestone before closing the current one.** If you realize mid-milestone that the goal has changed, restructure: close what's done, redefine the remainder as a new milestone, move deferred items.

---

## Deliverable Lifecycle

1. **Create** — add to TDD.md with DEL number, one-line description, status "Not started". Must trace to current milestone.
2. **Plan** — write `process/plan-del-XXX-name.md`. Include: acceptance criteria, docs in scope, steps (design and/or engineering). Reference in TDD.md.
3. **Execute** — follow the plan. Design steps use DESIGN mode. Engineering steps use EXECUTION mode. Update Now.md to track progress.
4. **Verify** — acceptance criteria met, tests pass, living docs updated.
5. **Close** — mark complete in TDD.md. Move plan to `process/archive/`.

**Each deliverable's plan lists docs in scope** — which docs will be read, created, or modified. This prevents putting content in the wrong place.

---

## Plan Revisions

Plans change during execution. When they do:

1. **Update the plan file directly.** Note what changed and why at the top (version note, like "v3: Added ACs for X after red team findings").
2. **Re-verify ACs still cover the new scope.** If scope expanded, ACs must expand. If scope contracted, remove ACs that no longer apply.
3. **Check docs in scope.** A plan revision may add or remove docs. Update the table.
4. **If the revision changes the deliverable's goal**, that's not a plan revision — it's a new deliverable or a milestone restructure.

---

## Connecting Design and Engineering

Design and engineering are not separate tracks. They're modes within a deliverable:

1. Deliverable gets planned.
2. Plan has design steps and/or engineering steps.
3. Design steps run in DESIGN mode (follow [design-mode.md](design-mode.md)).
4. Engineering steps run in EXECUTION mode (follow [execution-mode.md](execution-mode.md)).
5. Both update the same living doc. Design writes "what we decided." Engineering updates to "what was built."

**The handoff:** A design step produces a spec or living doc update. An engineering step implements against it. The plan makes the sequence explicit.

**Don't mix modes within a step.** If a design question surfaces during engineering, log it and return to a design step. If you're tempted to code during a design step, stop.
