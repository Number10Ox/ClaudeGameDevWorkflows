# Diagram 2: Execution Cycle

> "What happens during EXECUTION? What are the steps, quality gates, and who does what?"

This is the "work plane" — the deliverable lifecycle from story map through sign-off, showing artifacts, gates, actors, and persistent constraints.

---

## Layout

**Left-to-right main flow** across the top. **Persistent constraints** as a horizontal bar across the bottom. **Actor swim lanes** (Human / AI) as subtle background shading.

```
[Story Map] → [Deliverable] → [Readiness Gate] → [Red Team] → [Spec Freeze] → [Checkpoints] → [Sign-off] → [Session Wrap]
                                                                                    |
                                                                    +---[Checkpoint Gates]---+
                                                                    | G1 | G2 | G3 | G4     |
                                                                    +------------------------+

==[PERSISTENT: Sacred Contract Tests + Invariants must stay green]================================
```

---

## Boxes — Main Flow

| ID | Label | Description | Color | Actor |
|----|-------|-------------|-------|-------|
| S1 | **Story Map** | User journey → walking skeleton → vertical slices | Green `#D4EDDA` | Human |
| S2 | **Deliverable** | Discrete chunk with title, description, acceptance criteria | Blue `#D6EAF8` | Artifact |
| S3 | **Execution Readiness Gate** | All 4 checks must pass before implementation starts | Orange `#FFE0B2` | Gate |
| S4 | **Red Team Spec** | AI attacks the spec for ambiguities and loopholes | Purple `#E8DAEF` | AI |
| S5 | **Spec Freeze** | Behavioral specs locked. Changes need explicit proposal + Decisions.md | Orange `#FFE0B2` | Gate |
| S6 | **Plan** | Decompose deliverable into tasks. Plan mode, review as staff engineer | Green `#D4EDDA` | Human + AI |
| S7 | **Implement with Checkpoints** | Builder agents execute. Human validates at each gate | Green `#D4EDDA` | AI (build) + Human (validate) |
| S8 | **Sign-Off** | All acceptance criteria pass. Tests green. Code reviewed | Pink `#FDEDEC` | Human |
| S9 | **Session Wrap** | Now.md updated, tests green, design questions logged, committed | Green `#D4EDDA` | Human |

### Main flow arrows

S1 → S2 → S3 → S4 → S5 → S6 → S7 → S8 → S9

---

## Boxes — Checkpoint Gates (under S7)

| ID | Label | Description | Color | Validates |
|----|-------|-------------|-------|-----------|
| G1 | **Plumbing Compiles** | Types, interfaces, function signatures exist. Project builds | Orange `#FFE0B2` | Structure |
| G2 | **First Playable Loop** | Minimal path works end-to-end | Orange `#FFE0B2` | Integration |
| G3 | **Edge Cases + Invariants** | Failure states, boundary conditions, property tests | Orange `#FFE0B2` | Robustness |
| G4 | **Polish + Acceptance** | Final UX, messaging, all acceptance criteria met | Orange `#FFE0B2` | Completeness |

**Flow:** G1 → G2 → G3 → G4, each with a "Human validates" arrow back up

**Annotation on checkpoint group:** "Claude does not proceed past a gate without human validation"

---

## Boxes — Persistent Constraints (bottom bar)

| ID | Label | Description | Color |
|----|-------|-------------|-------|
| P1 | **Sacred Contract Tests** | Core loop completes, failure understandable, loop repeats. Must stay green | Pink `#FDEDEC` |
| P2 | **Invariants** | Rules that always hold (determinism, non-empty causes, score consistency) | Pink `#FDEDEC` |
| P3 | **Project Constraints** | No `any` types, pure engine functions, immutable state, no classes for logic | Pink `#FDEDEC` |

**These run against every checkpoint.** Draw arrows from P1/P2/P3 up to each gate (G1-G4).

---

## Boxes — AI Agent Roles (right margin or overlaid)

| ID | Label | When | Color |
|----|-------|------|-------|
| A1 | **Red Team Agent** | Before spec freeze (S4) | Purple `#E8DAEF` |
| A2 | **Builder Agent** | During implementation (S7) | Purple `#E8DAEF` |
| A3 | **Validator Agent** | At each checkpoint (G1-G4) | Purple `#E8DAEF` |
| A4 | **Reviewer Agent** | At sign-off (S8) | Purple `#E8DAEF` |

### Agent arrows

| Agent | Connects to | Label |
|-------|-------------|-------|
| A1 | S4 | "List ambiguities, underspecified behaviors, minimal-wrong passes" |
| A2 | S7 | "Implements against frozen spec" |
| A3 | G1-G4 | "Checks constraints, canon docs, acceptance criteria" |
| A4 | S8 | "Reviews patch against behavioral specs + invariants" |

---

## Side Callouts

### Callout 1: Execution Readiness Gate Details (near S3)

```
READINESS GATE
[ ] Acceptance criteria defined (concrete, testable)
[ ] Unknowns resolved or deferred (logged in Now.md)
[ ] Constraints pinned (documented, non-negotiable)
[ ] Behavioral specs written (human-authored)
```

### Callout 2: Spec Freeze Rules (near S5)

```
SPEC FREEZE RULES
- AI must present changes as "Proposed spec change" with tradeoffs
- Any change needs Decisions.md entry
- Significant revision → return to DESIGN mode
- Prevents "boiled frog" drift
```

### Callout 3: Sign-Off Checklist (near S8)

```
SIGN-OFF CHECKLIST
[ ] All acceptance criteria have passing tests
[ ] Edge cases identified and tested
[ ] No regressions: full test suite green
[ ] Tech design doc updated if architecture changed
[ ] Code review: bugs, type safety, constraint adherence
```

### Callout 4: Escalation Rules (right margin)

```
ESCALATION RULES
AI may decide:
  naming, file placement, refactors within slice

AI must escalate:
  spec change, canon doc change, new mechanic,
  new dependency, perf budget exception
```

### Callout 5: Session Wrap (near S9)

```
SESSION WRAP
[ ] Now.md current (where you stopped, what's next)
[ ] Design questions logged (not resolved inline)
[ ] Tests green
[ ] Tech design doc updated if needed
[ ] Committed (WIP commit is fine, uncommitted is not)
```

---

## Connections to Documents

| Step | Document | Action | Arrow style |
|------|----------|--------|-------------|
| S1 (Story Map) | TDD.md | Reads deliverable breakdown | Dashed, downward |
| S2 (Deliverable) | TDD.md | Defined in Section 11 | Dashed, downward |
| S3 (Readiness Gate) | SettledDesign.md | Checks against established design | Dashed, downward |
| S5 (Spec Freeze) | Decisions.md | Logs any spec change | Solid, downward |
| S8 (Sign-Off) | TDD.md | Updates if architecture changed | Dashed, downward |
| S9 (Session Wrap) | Now.md | Updates active task, state | Solid, downward |

---

## Annotations on Arrows

| Arrow | Text |
|-------|------|
| S1 → S2 | "Walking skeleton row first" |
| S2 → S3 | "All 4 checks must pass" |
| S3 → S4 | "Spec written, now attack it" |
| S4 → S5 | "Fix spec, then freeze" |
| S5 → S6 | "Plan in plan mode" |
| S6 → S7 | "Switch to auto-accept after plan approved" |
| S7 → S8 | "All gates passed" |
| S8 → S9 | "or back to S2 for next deliverable" |
| G1 → G2 → G3 → G4 | "Human validates at each gate" |

---

## Color Legend (include on diagram)

| Color | Meaning |
|-------|---------|
| Yellow `#FFF3C4` | Human decision / action |
| Green `#D4EDDA` | Process step |
| Orange `#FFE0B2` | Gate / checkpoint (must pass) |
| Blue `#D6EAF8` | Document / artifact |
| Purple `#E8DAEF` | AI agent action |
| Pink `#FDEDEC` | Test / validation / persistent constraint |
