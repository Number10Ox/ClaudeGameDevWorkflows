# UI Specification Workflow

How screens get specified, implemented, and verified when working with Claude Code.

---

## The Contract

The screen spec is the **primary UI contract** between you and Claude. It determines what "done" looks like.

- **If it's in the spec, Claude builds it.**
- **If it's not in the spec, Claude asks** — not invents.
- **If Claude spots a gap during implementation** (e.g., a state that wasn't specified, an interaction that's ambiguous), Claude flags it and waits for direction.

This is a one-way authority: the spec drives implementation. Claude does not silently add elements, states, or behaviors that aren't specified.

---

## When to Write a Screen Spec

| Situation | Spec needed? |
|-----------|-------------|
| New screen or view | Yes |
| Major redesign of existing screen (layout change, new regions) | Yes |
| Adding a significant new element to an existing screen | Yes — update the existing spec |
| Minor tweaks (change a label, adjust spacing, fix a color) | No |
| Bug fix that doesn't change intended behavior | No |

**Rule of thumb:** if the change affects layout, adds interactive elements, or introduces new states, update or create a spec.

---

## Spec Artifacts

### Required: Screen Spec (text)

Use the template at [templates/screen-spec.md](../templates/screen-spec.md). The spec covers:

1. **Purpose** — what the screen does for the player
2. **Layout** — spatial hierarchy as an indented tree with positioning rules
3. **Elements** — every interactive or data-driven element with type, content, interaction, and notes
4. **Data** — what data the screen consumes and where it comes from
5. **States** — every meaningful state (Loading, Empty, Error, Populated, plus game-specific states)
6. **Navigation** — how the player gets here and where they go next
7. **Style Notes** — mood and constraints, not pixel values

### Optional: Visual Wireframe

Attach a wireframe image when the layout tree alone doesn't convey spatial intent — proportions, visual weight, or the "feel" of the arrangement.

- Can be OmniGraffle, Excalidraw, pen-on-paper photo, or any image Claude can read
- The text spec is authoritative on conflicts — the wireframe is a supplement, not a source of truth
- Most useful for: novel layouts, multi-pane arrangements, or screens where proportions matter

### Not needed: Pixel-perfect comps

Figma-level specifications are unnecessary for prototype work. If the project reaches production with a design team handoff, that's a different workflow.

---

## Implementation Workflow

### 1. Spec Review (before writing code)

Claude reads the full spec and confirms understanding:
- Identifies any ambiguities or missing information
- Asks clarifying questions before starting
- Does NOT begin implementation with known gaps

### 2. Implementation

Claude implements the spec section by section:
- Layout tree maps to DOM/canvas structure
- Elements table drives what gets rendered and how it behaves
- Data section drives what state is needed
- States section drives conditional rendering

### 3. Verification (after implementation)

Claude walks the spec **section by section** and confirms each requirement is met:

| Section | Verification |
|---------|-------------|
| Layout | Structure matches the tree. Spatial rules respected. |
| Elements | Every element in the table exists, has correct type, content, and interaction. |
| Data | All data fields are sourced correctly. |
| States | Each listed state renders correctly. Transitions between states work. |
| Navigation | Entry and exit paths function. |
| Style Notes | Mood/constraints are respected (subjective — flag if uncertain). |

If verification reveals a gap, Claude fixes it before reporting done.

---

## Updating Specs

Specs are living documents — they stay current with the implementation.

- **During implementation:** if a spec gap is discovered and resolved, update the spec to match the decision made.
- **After implementation:** if the screen changes in a later deliverable, update the spec first, then implement.
- **Stale specs are worse than no specs.** If a spec no longer matches reality, either update it or delete it.

---

## Where Specs Live

Place screen specs in your project's docs directory alongside other design documents. Naming convention:

```
Docs/screen-spec-[screen-name].md
```

For projects with many screens, a subdirectory is fine:

```
Docs/screens/[screen-name].md
```

---

## Relationship to Other Workflows

- **DESIGN mode** — screen specs often emerge from design sessions. The spec is the output of a UI/UX layer design conversation. Write the spec, then switch to EXECUTION mode to implement it.
- **EXECUTION mode** — the spec is part of the plan. Implementation follows the spec the way it follows acceptance criteria.
- **SettledDesign.md** — high-level screen descriptions and required information live in SettledDesign. Screen specs are the detailed version for implementation.

---

> **Adapt this:** The verification step can be as formal or informal as your project needs. For prototypes, a mental walkthrough is enough. For production, you might add automated visual regression tests or a QA checklist derived from the spec. The contract (spec is authoritative, gaps get flagged) stays the same regardless of formality level.
