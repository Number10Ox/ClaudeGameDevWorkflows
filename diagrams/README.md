# Workflow Diagrams

Build sheets for creating visual workflow diagrams in Figma (or similar). Each file describes boxes, connections, colors, and annotations — you build the diagram from the spec.

## Diagrams

| File | What it shows | Audience question |
|------|--------------|-------------------|
| [01-mode-and-docs.md](01-mode-and-docs.md) | DESIGN vs EXECUTION modes, canon documents, mode transitions, write-back rules | "How does the overall system work? When do I read/write what?" |
| [02-execution-cycle.md](02-execution-cycle.md) | Story map through sign-off: deliverables, gates, specs, checkpoints, agents | "What happens during EXECUTION? What are the steps and quality gates?" |

## Color System

Used consistently across all diagrams:

| Color | Hex | Meaning |
|-------|-----|---------|
| Warm yellow | `#FFF3C4` | Human action / decision |
| Light green | `#D4EDDA` | Process step / workflow |
| Light orange | `#FFE0B2` | Gate / checkpoint (must pass) |
| Light blue | `#D6EAF8` | Document / artifact |
| Light purple | `#E8DAEF` | AI agent action |
| Light pink | `#FDEDEC` | Test / validation |
| White | `#FFFFFF` | Annotation / callout |

## Design notes

- Boxes have a **title** (bold, 12-14pt) and optional **description** (regular, 10pt)
- Arrows are labeled with trigger text or artifact names
- Group boxes with dashed borders to show phases or planes
- Side callouts (like the estimates box in the example) use white background with thin border
- Duration/frequency annotations go on or near arrows
