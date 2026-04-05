---
name: doc-review
description: "Use when reviewing any structured artifact (design spec, living doc, plan, process doc) for gaps, regressions, ambiguities, and contradictions."
---

> **Adapt this:** Update the source doc references and add project-specific regression checks (terminology, mechanic names, etc.) to the checklist.

# Doc Review

Reviews structured documents for completeness and consistency. Complements domain-specific quality gates — this checks document structure, not domain content.

## On Invocation

1. Read [CHECKLIST.md](references/CHECKLIST.md)
2. Read the artifact to review (passed as `$ARGUMENTS` or identified from context)
3. Identify referenced/cited documents and read first-level dependencies

## Review Protocol

Run four checks against the artifact:

### A. Gap Analysis
Does the artifact cover everything it claims to cover? Missing sections, undefined concepts, dangling references.

### B. Regression Analysis
Does the artifact preserve everything from its source material? Dropped mechanics, changed terminology, missing validation rules.

### C. Ambiguity Scan
Could two implementers read this differently? Unspecified thresholds, missing edge cases, vague scope qualifiers.

### D. Internal Consistency
Does the artifact contradict itself? Section vs section, prose vs tables, claims vs acceptance criteria.

## Output Format

For each finding:
- **Category + number** (e.g., A3, C1)
- **Severity:** FIX (must resolve) / EDGE (add test case) / OK (examined, no issue)
- **Description:** What's wrong and where

**Exit criteria:** Zero FIX results. EDGE results noted in the artifact or tracked.

## When to Use

- Reviewing design specs before implementation
- Reviewing living docs after major updates
- Reviewing plans (complements `/plan` red team — this checks document quality, `/plan` checks plan quality)
- Reviewing process docs for self-consistency

## When NOT to Use

- Player-facing narrative — use your narrative quality gate
- Implementation plans — use `/plan` (has red team + hold-out review)
- Authored game content — use your content quality gate
