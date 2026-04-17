# Living Design Doc Template

> Copy this template when creating a new per-system living doc. Place in your project's `Docs/` or `Docs/Design/` directory.

**Size target:** Under 200 lines. If it's longer, the system is too coupled or the doc is too detailed. Section headings are mandatory; section content scales with system complexity.

**Update rule:** Each section is either current reality (implemented in code) or ahead-of-implementation design. Distinguish them using **implementation status tags** in the heading — see [Implementation Status Tags](#implementation-status-tags) below. When implementation catches up to a `[SPEC]` section, remove the tag. Avoid mixing "implemented now" and "designed for later" in the same untagged section.

---

## Template: `{SystemName}.md`

```markdown
# {System Name}

**Last updated:** {date or commit hash}

## What It Does

2-3 sentences. What the player experiences. What the system produces.

## Requirements

Constraints any design and implementation of this system must satisfy. Numbered `REQ-XX-###` where `XX` is the system's short code (e.g., `REQ-MG-001` for a MissionGameplay system). Append-only — if a requirement changes, add a new one and mark the old one **superseded by REQ-XX-###**, keeping the original line for audit.

Plans that touch this system cite these IDs; `plan-guard.sh` enforces the cite mechanically (see `workflows/design-mode.md` § Requirements Capture).

Example:

- **REQ-MG-001 — Narrator implementation must be substitutable.** A fixture narrator (deterministic, pre-authored text, no LLM calls) must be able to fulfill the same contract as an LLM narrator. Rationale: enables golden-script validation, regression testing, and development without LLM dependency.
- **REQ-MG-002 — Missions must run autonomously.** The mission runtime must complete without player input at any decision point. Rationale: enables automated validation sweeps and headless testing.

Omit this section only if the system has no external constraints worth capturing. If `plan-guard.sh` keeps blocking plans that touch this system, that's a signal the section belongs here after all.

## How It Works

Mechanics, data flow, key types. Enough for Claude Code to implement against without reading the full codebase. Not a code walkthrough — describe behavior and contracts.

### {Subsection per major component}

Break into subsections as needed. Each subsection describes one component's behavior and its interfaces.

### {Some Future Component} [SPEC]

Design is decided, implementation is not done. While this tag is present, the doc is the source of truth — the code will not match. Remove the tag when the referenced behavior is wired up and tested.

## Interfaces

Other systems this one touches. For each interface:
- **{Other System}** — what crosses the boundary, in which direction. Reference the other system's living doc.

Example:
- **Combat System** — receives damage events from encounter resolution. Sends status band updates back. See CombatSystem.md § Damage Events.

## Current Scope

What's built and working. Bullet list.

## Deferred

What's explicitly not built yet and why. Reference the milestone where it's planned.

Example:
- Multiplayer matchmaking — M3, after single-player loop is stable
- Leaderboard integration — M4

## Open Questions

Unresolved design questions. Each should reference where it's being tracked (Now.md, a deliverable, or a design session).
```

---

## Implementation Status Tags

Sections in a living doc describe either implemented reality or ahead-of-implementation design. Readers (human or Claude) need to know which is which so they don't treat absence-from-code as evidence that the system is undesigned — and so they don't trust stale doc claims about what the code does.

Convention:

- **Untagged section** — describes implemented code. A reader should trust that grepping the referenced code files will find matching types, behavior, and constants. Claude, when opening a new session, can treat the code as source of truth for any content in an untagged section.
- **`[SPEC]`** — section describes design that is not yet (or not fully) implemented. The doc is the source of truth for this content; code absence does not mean "undesigned," it means "designed, not built yet." Claude, when opening a new session, should treat the doc's `[SPEC]` content as authoritative and not assume from missing code that the work hasn't been thought through.
- **`[SPEC → D-###]`** — optional trace to the specific deliverable where the implementation will land.

Example headings:

- `## How It Works` — implemented, default
- `## Call 2 Route Selection [SPEC]` — designed, not yet wired
- `## Anomaly Bleed Ledger [SPEC → D-051]` — designed in D-051, pending M7

**When implementation catches up**, remove the tag and update the section to describe current reality (trim speculative content, add concrete behavior). Don't leave `[SPEC]` tags on sections the code now matches.

**For auditing:** `grep -E '^##.*\[SPEC\]'` finds every not-yet-implemented section. Absent tags mean code is authoritative for that section.

> **Adapt this:** If your team prefers different tag names (e.g., `[DESIGNED]`/`[BUILT]`, or per-milestone tags), pick one vocabulary and document it at the top of the template. The principle is: a reader can tell, without reading the code, whether a section is describing code or ahead-of-code.

---

## Cross-Reference Format

When referencing another living doc, use: `See {DocName}.md § {Section}`. This gives review tools a parseable format to check for interface drift between systems.

## When to Create a Living Doc

Create one when you're about to make a change to a system and no living doc exists. Writing the living doc for the current state is the first deliverable. Don't pre-create empty docs for systems you're not touching.

## Relationship to SettledDesign.md

Living docs replace the monolithic `SettledDesign.md` approach. Instead of one doc that describes the entire game, each system owns its own doc that describes current reality. The SettledDesign.md template is still available for projects that prefer a single-doc approach, but living docs scale better as system count grows.

> **Adapt this:** The section headings are suggestions. Your systems may need different subsections. The 200-line cap is the forcing function — if a doc is too long, the system probably needs to be split or the doc is over-detailed.
