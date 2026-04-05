# Review Checklist

Quick-scan reference for the doc-review skill. Categories match the four checks in SKILL.md.

## A. Gap Analysis

- [ ] A1: Every referenced concept is defined (in the artifact or a first-level cited doc)
- [ ] A2: Every section promised by the structure exists and has content
- [ ] A3: Every acceptance criterion is addressed by at least one section
- [ ] A4: Every interface listed has a clear, bidirectional relationship
- [ ] A5: No dangling cross-references (pointers to nothing)
- [ ] A6: No unresolved TODO, TBD, or "to be determined" markers

## B. Regression Analysis

- [ ] B1: Every mechanic in referenced source docs is present or explicitly deferred
- [ ] B2: No validation checks dropped between versions
- [ ] B3: Terminology matches project naming conventions

> **Adapt this:** Add project-specific regression checks here. Examples:
> - B4: All handler verbs accounted for (if applicable)
> - B5: All stat/display rules present (if applicable)

## C. Ambiguity Scan

- [ ] C1: All numeric thresholds specified (not "some" or "several")
- [ ] C2: Edge cases addressed (zero, max, boundaries between bands/states)
- [ ] C3: Scope qualifiers specified ("per path" / "worst case" / "any path")
- [ ] C4: Ownership boundaries explicit (which system owns what)
- [ ] C5: No term used with two different meanings in the same artifact
- [ ] C6: Minimal-wrong-interpretation test — no reductive reading satisfies ACs while missing intent

## D. Internal Consistency

- [ ] D1: No section contradicts another section
- [ ] D2: Acceptance criteria are mutually compatible
- [ ] D3: No conflict with project decisions log (check recent entries)
- [ ] D4: Claims in prose match claims in tables/formulas

## Quick-Scan (optional pre-check)

Run before the full review to catch obviously incomplete artifacts early:

1. Scope statement — does the content match the claimed scope?
2. Acceptance criteria count — enough to verify the design?
3. Interfaces — does every listed system have a clear relationship?
4. Final section — ends cleanly or trails off?
5. Artifact references — can every cited doc actually be found?
