# Living Design Doc Template

> Copy this template when creating a new per-system living doc. Place in your project's `Docs/` or `Docs/Design/` directory.

**Size target:** Under 200 lines. If it's longer, the system is too coupled or the doc is too detailed. Section headings are mandatory; section content scales with system complexity.

**Update rule:** Updated after implementation, not before. Describes current reality. If a section says "planned" or "proposed," it belongs in a proposal or deliverable, not here.

---

## Template: `{SystemName}.md`

```markdown
# {System Name}

**Last updated:** {date or commit hash}

## What It Does

2-3 sentences. What the player experiences. What the system produces.

## How It Works

Mechanics, data flow, key types. Enough for Claude Code to implement against without reading the full codebase. Not a code walkthrough — describe behavior and contracts.

### {Subsection per major component}

Break into subsections as needed. Each subsection describes one component's behavior and its interfaces.

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

## Cross-Reference Format

When referencing another living doc, use: `See {DocName}.md § {Section}`. This gives review tools a parseable format to check for interface drift between systems.

## When to Create a Living Doc

Create one when you're about to make a change to a system and no living doc exists. Writing the living doc for the current state is the first deliverable. Don't pre-create empty docs for systems you're not touching.

## Relationship to SettledDesign.md

Living docs replace the monolithic `SettledDesign.md` approach. Instead of one doc that describes the entire game, each system owns its own doc that describes current reality. The SettledDesign.md template is still available for projects that prefer a single-doc approach, but living docs scale better as system count grows.

> **Adapt this:** The section headings are suggestions. Your systems may need different subsections. The 200-line cap is the forcing function — if a doc is too long, the system probably needs to be split or the doc is over-detailed.
