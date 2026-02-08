# SettledDesign.md Template

> Copy this to your project as `Docs/SettledDesign.md`.
> This is the single source of truth for "what IS the game right now."
> Not history, not proposals — current state only. Updated via decision log entries.

---

```markdown
# Settled Design Elements

These elements are **required** in all prototype representations. Do not omit unless explicitly deciding to change/remove with documented reasoning.

## Core Loop

[Describe the fundamental game loop in 3-7 steps. What does the player do? What does the system do? What's the cycle?]

1. **[Step 1]** — [description]
2. **[Step 2]** — [description]
3. **[Step 3]** — [description]
4. **[Step 4]** — [description]

## Canonical Data Model

[Name your canonical model and describe how UI components consume it.]

`[ModelName]` is the canonical model. UI components consume derived views via adapters:

```
[ModelName] (canonical)
  ├─ adapt[X](model)  → [ViewType]   ([where used])
  ├─ adapt[Y](model)  → [ViewType]   ([where used])
  └─ adapt[Z](model)  → [ViewType]   ([where used])
```

## Outcome States

[What are the possible outcomes? Every game has some form of success/partial/failure.]

- **[SUCCESS_TERM]** — [description]
- **[PARTIAL_TERM]** — [description]
- **[FAILURE_TERM]** — [description]

## Required Information

### [Phase/Screen 1]
- [What must be shown]
- [What the player can do]
- [Key UI elements with their names]

### [Phase/Screen 2]
- [What must be shown]
- [What the player can do]

### [Phase/Screen 3]
- [What must be shown]
- [Mandatory elements with rationale]

## Design Invariants

These guardrails apply to every change. If a modification violates any of these, it's wrong.

1. **[Invariant 1]** — [description]
2. **[Invariant 2]** — [description]
3. **[Invariant 3]** — [description]

## Terminology

| Concept | Canonical Term | Deprecated / Alternative Terms |
|---------|---------------|-------------------------------|
| [concept] | [current term] | [old terms] |
| [concept] | [current term] | [old terms] |

## Style Bible (if applicable)

[If your game has multiple text/voice channels, document them here. The pattern: define each channel's role, tone, POV, length limits, good/bad examples, and dedup rules.]

### [Channel 1 Name]
- **Role:** [what information this channel carries]
- **Tone:** [description]
- **POV/Tense:** [e.g. 1st person present]
- **Length:** [limits]

### [Channel 2 Name]
- **Role:** [what information this channel carries]
- **Tone:** [description]

### Channel Separation Rules
[How to prevent channels from being redundant. Priority order for dedup.]

## What Can Change Between Representations
- [Things that are skinnable / swappable]

## What Must NOT Change
- [Non-negotiable structural elements]

## Architecture

### Key Components
- `[file]` — [purpose]
- `[file]` — [purpose]
```

---

> **Adapt this:** Every section above is optional — include what's relevant to your game. The minimum useful SettledDesign.md has: Core Loop, Outcome States, Terminology, and Design Invariants. The style bible pattern is only needed if your game has multiple narrative voices or text channels.
