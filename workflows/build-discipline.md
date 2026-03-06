# Build Discipline (EXECUTION Mode Companion)

Response-level rules for how Claude structures each turn during execution. These complement execution-mode.md (which covers the *process*) by constraining the *output format*.

> Sources: Reconciled from an external ChatGPT-generated "LLM Build Playbook" with existing ClaudeGameDevWorkflows patterns. The playbook contributed the artifact-first format, drift headers, and Three Anchors. Everything else was already covered.

---

## Artifact-First Responses

During EXECUTION mode, every Claude response must lead with the artifact (code, config, spec, plan file), not with explanation.

**The rule:** explanation serves the artifact, not the other way around. If Claude writes 3 paragraphs before showing code, something is wrong.

- Keep explanation outside the artifact to a few sentences of context
- If extended reasoning is needed, put it in code comments inside the artifact
- Don't re-state what the user said — just do the work

**When this doesn't apply:**
- DESIGN mode (exploring, ideating, discussing options)
- Research tasks (investigating APIs, reading code, answering questions)
- Error diagnosis (explaining what went wrong and why)

> **Adapt this:** Some teams prefer more explanation. The principle is: don't bury the deliverable under prose. If the user wanted a lecture, they'd ask.

---

## Per-Artifact Drift Headers

For significant artifacts (specs, plans, multi-file changes), include drift control metadata at the top. This prevents the common failure where Claude silently changes scope across iterations.

```
VERSION: 3
SCOPE: Add grid-based lot system with weighted district distribution
DO NOT CHANGE: river geometry, district boundaries, Y-layer constants, dusk grading
CHANGE ONLY: lot assignment logic, variant selection, debug overlay
```

**When to use:** Plan files, spec files, multi-pass work. Not needed for small fixes or single-file changes.

**How it works:**
- `VERSION` increments on each revision
- `SCOPE` is one sentence — if you can't say it in one sentence, the scope is too big
- `DO NOT CHANGE` lists 3-8 things that are frozen for this pass
- `CHANGE ONLY` lists 1-3 things being modified

If Claude violates DO NOT CHANGE, the artifact is wrong. This is checkable by the user and by Claude itself during self-review.

> **Adapt this:** The header format is a suggestion. Some projects prefer a simpler "SCOPE / FROZEN" pair. The principle is: make scope explicit at the top of every non-trivial artifact.

---

## Three Anchors

Before generating any significant artifact, Claude should silently verify three things:

### A) Structure (Bounded Vocabulary)

Use the existing types, schema, and layer model. Don't invent new concepts unless asked.

- If there's an existing enum, extend it — don't create a parallel one
- If there's a type system, use it — don't work around it with loose strings
- If no schema exists for what you're building, create a minimal one first

### B) Golden Example (Target)

Align to at least one concrete example of what "correct" looks like.

- If a golden example exists in the codebase, treat it as the spec
- If none exists, create one minimal golden example before building the full system
- The example should be small enough to verify by eye

### C) Hard Constraints (Checkable)

Maintain a short list of constraints that are machine-testable or human-checkable.

- Prefer automated tests over manual checklists
- No more than 10 constraints per deliverable
- Every constraint must be verifiable — "make it look good" is not a constraint; "no building model > 8% of placements" is

> **Adapt this:** The Three Anchors are a mental checklist, not a ceremony. Claude doesn't need to print them — just verify them before producing output.

---

## Iteration Protocol (Passes)

Work in passes. Each pass changes one dimension and keeps everything else stable.

| Pass changes | Everything else is frozen |
|---|---|
| Topology (layout, grid, boundaries) | Content, lighting, narrative |
| Variety (models, textures, distributions) | Layout, lighting, narrative |
| Lighting / atmosphere | Layout, content, narrative |
| Narrative (text, events, triggers) | Layout, content, lighting |
| UI (screens, controls, feedback) | Everything backend |

If the user says "tune one at a time," Claude must propose ONE pass and explicitly name what's frozen.

This prevents the most common drift failure: "fix the river" turns into "fix the river AND restructure the building system AND change the lighting." Each of those is a separate pass.

> **Adapt this:** Your passes depend on your project. The principle is: change one dimension, validate it, then move to the next.

---

## Validation Discipline

Every artifact that changes behavior must include a validation plan.

**For code changes:**
- At minimum: "run the build, verify no errors"
- Better: specific test commands or assertions
- Best: automated tests that prove correctness

**For specs or plans:**
- 3-8 bullet checklist of what "done" looks like
- Each bullet must be verifiable (testable or visually confirmable)

**For procedural/generated content:**
- Deterministic validation: same seed must produce same result
- Statistical validation: variety caps, distribution checks, constraint satisfaction
- Visual validation: specific things to look for in screenshots

This complements the [Sacred Contract Tests](execution-mode.md) and [Verification Loop](execution-mode.md) from execution-mode.md. Those cover system-level invariants. Validation discipline covers per-artifact correctness.

---

## When Unsure

Don't ask 10 questions. Do one of:

1. **Provide two viable defaults (A/B), pick one, label it clearly.** The user can redirect if they disagree.
2. **Add an `ASSUMPTION:` label and proceed.** This makes your guess visible and correctable.
3. **Make the artifact configurable** — put the uncertain value as a named constant at the top of the file.

This applies during EXECUTION only. In DESIGN mode, asking questions is the whole point.

---

## Style Requirements (Domain-Specific)

### Map / Layout / City Content

These rules apply when building spatial content (maps, levels, cities, dungeons):

- Use a **grid or slots model**, not free scatter. Every placement has a coordinate.
- Every placed object must have a **semantic reason** (LotType, PlaceType, RoomType). No random decoration.
- Enforce **variety caps** — no single model/variant exceeds a percentage threshold (e.g. 8%).
- Rivers, roads, and boundaries are **first-class assets** with continuity rules, not texture overlays.
- Placement must be **deterministic** — same seed produces same layout.
- Anti-repetition rules must be **spatial** (minimum distance), not just statistical.

### Narrative / Text Content

These rules apply when writing player-facing text:

- Keep messages short (configurable per project, default ~160 chars)
- "Source-first" ordering: action, then observation, then inference
- Limit anomaly "tells" per segment (max 2 per room/scene)

> **Adapt this:** These are extracted from specific projects (Context Drift, Vela City Map). Your project may have different spatial or narrative constraints. The principle is: write down the domain-specific rules that Claude keeps forgetting, and put them where Claude will see them every session.

---

## Relationship to Other Workflows

| This doc covers | Other docs cover |
|---|---|
| How Claude structures each response | When to design vs execute (design-mode.md) |
| Per-artifact drift control | Session-level drift control (Now.md, write-back ritual) |
| Validation per artifact | System-level invariants (sacred contract tests) |
| When to ask vs assume | What questions to explore (design-mode.md) |
| Domain-specific style rules | General engineering practices (execution-mode.md) |
