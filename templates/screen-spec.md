# Screen Spec Template

> Copy this to your project for each screen or major screen change.
> The screen spec is the **primary UI contract** — Claude implements what's in the spec, flags what's missing, and verifies against it section by section.
> Optional: attach a wireframe image for spatial relationships that are hard to express in text.

---

```markdown
# Screen Spec: [Screen Name]

## Purpose
<!-- One sentence. What does this screen do for the player? -->


## Orientation & Viewport
- **Target**: desktop | mobile-landscape | mobile-portrait
- **Min width**: (e.g., 1024px, 375px)
- **Scrollable**: yes | no | vertical-only

---

## Layout

<!--
Describe the screen as a tree. Indentation = nesting.
Each node gets: name, role, and spatial rule.

Spatial rules (pick one per node):
  fixed-top | fixed-bottom | fixed-left | fixed-right
  fill-remaining
  row(weight) | col(weight)   — weight is relative, e.g., row(1) row(2) = 1/3 and 2/3
  stack                        — children overlap (tabs, modals)
  scroll-y | scroll-x

Size hints (optional):
  h: fixed(60px) | min(40px) | max(300px) | hug
  w: fixed(200px) | fraction(1/3) | hug
-->

```
Screen: [name]
├── [region-name] | [spatial-rule] | [size-hint]
│   ├── [element] | [spatial-rule]
│   └── [element] | [spatial-rule]
├── [region-name] | [spatial-rule]
│   └── ...
└── [region-name] | [spatial-rule]
```

---

## Elements

<!--
One row per interactive or data-driven element from the layout tree.
Skip purely structural containers.
-->

| Element | Type | Content / Data | Interaction | Notes |
|---------|------|---------------|-------------|-------|
| | button / text / input / list / toggle / slider / canvas / image / dropdown / tabs | What it shows or where data comes from | What happens on click/change/hover | Sizing, emphasis, disabled states, conditional visibility |

---

## Data

<!-- What data does this screen need? Where does it come from? -->

| Field | Type | Source | Example value |
|-------|------|--------|---------------|
| | | prop / api / local-state / route-param / engine-state | |

---

## States

<!--
What are the meaningful states this screen can be in?
Include at minimum: Loading, Empty, Error, Populated.
Add game-specific states as needed (e.g., Paused, Game Over).
-->

- **Loading**:
- **Empty**:
- **Error**:
- **Populated**: (default, as described above)

---

## Navigation

- **Entry**: How does the player get here?
- **Exits**: Where can the player go from here?

---

## Style Notes

<!--
Mood and constraints, not pixel-perfect specs.
e.g., "dense, data-heavy", "minimal with lots of whitespace",
"dark theme", "match the settings screen style"
-->

```

---

> **Adapt this:** All sections are present by default. If a section genuinely doesn't apply (e.g., a HUD overlay has no Navigation), delete it rather than leaving it empty. For canvas-heavy games, the Elements table may describe rendered regions rather than DOM elements — that's fine, the contract still holds.
