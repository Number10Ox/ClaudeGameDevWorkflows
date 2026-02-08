# Decisions.md Template

> Copy this to your project as `Docs/Decisions.md`.
> Chronological. Each entry: what was decided, why, what it replaced.
> Deprecated terms and removed ideas are logged here, not silently deleted.

---

```markdown
# Decision Log

> Chronological. Each entry: what was decided, why, what it replaced (if anything).
> Deprecated terms and removed ideas are logged here, not silently deleted.

---

## D-001: [Decision Title]

**Date:** YYYY-MM-DD
**Layer:** [System / UI / Representation / Content / Economy / Production]
**Commit:** [hash or "design decision"]

[What was decided and why. 1-3 sentences.]

- **Deprecated:** [old terms, old approaches — makes them searchable]
- **Replaced:** [what this supersedes, if anything]
- **Rationale:** [why this over alternatives]
- **Revisit if:** [conditions that would make you reconsider]

---
```

---

## Example Entries

These show the pattern for different types of game dev decisions:

### Mechanic Decision

```markdown
## D-003: Combat resolution uses deterministic scoring, not LLM judgment

**Date:** 2026-01-15
**Layer:** System / Mechanics

All combat outcomes are determined by pattern matching rules, not by asking an LLM to evaluate quality. Scoring formula is visible and auditable.

- **Deprecated:** "AI-judged resolution" (concept from early brainstorm)
- **Rationale:** LLM judgment is non-reproducible and untestable. Deterministic scoring lets players learn the system.
- **Revisit if:** a specific mechanic genuinely requires subjective evaluation AND we find a reproducible way to do it
```

### Naming Decision

```markdown
## D-007: Player actions called "Protocols" (not "Spells" or "Clauses")

**Date:** 2026-02-01
**Layer:** Representation / Vocabulary

Player pre-commitments are called "Protocols" in the SCP/ops framing. This matches the institutional tone.

- **Deprecated:** "Spell" (fantasy framing), "Clause" (legal framing)
- **Rationale:** SCP/ops tone is procedural and grounded. "Protocol" implies pre-commitment + institutional context.
- **Revisit if:** framing shifts away from SCP/ops
```

### Architecture Decision

```markdown
## D-012: Single canonical data model, UI adapts via functions

**Date:** 2026-02-05
**Layer:** Tech / Architecture
**Commit:** abc1234

One canonical model (`GameRun`) is the source of truth. UI components consume derived views via adapter functions, not by reshaping the model per component.

- **Replaced:** Per-component data shapes that drifted from each other
- **Rationale:** prevents drift between different views of the same data
- **Revisit if:** performance requires pre-computed views or the model becomes unwieldy
```

---

> **Adapt this:** The entry format is the pattern. Use whatever layer names match your project. The key features: chronological, includes deprecated terms (searchable), includes revisit triggers (prevents eternal commitment).
