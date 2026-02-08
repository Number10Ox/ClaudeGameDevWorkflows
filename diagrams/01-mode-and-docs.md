# Diagram 1: Mode & Document System

> "How does the overall system work? When do I read/write what?"

This is the "control plane" — the state machine that governs how you work, what documents exist, and when they're touched.

---

## Layout

**Left-to-right flow**, two major zones side by side (DESIGN and EXECUTION), with a shared document row across the bottom.

```
+--[DESIGN ZONE]--------+     +--[EXECUTION ZONE]------+
|                        | <-> |                        |
|  (design activities)   |     |  (execution activities) |
|                        |     |                        |
+------------------------+     +------------------------+
               |                          |
               v                          v
+--[CANON DOCUMENTS]-------------------------------------------+
|  Now.md  |  Decisions.md  |  SettledDesign.md  |  Pillars   |
|          |                |                    |  TDD.md    |
+--------------------------------------------------------------+
```

---

## Boxes

### Mode States (center top — the state chart)

| ID | Label | Description | Color | Shape |
|----|-------|-------------|-------|-------|
| M1 | **DESIGN** | Exploring, ideating, deciding | Yellow `#FFF3C4` | Rounded rectangle, large |
| M2 | **EXECUTION** | Implementing settled decisions | Green `#D4EDDA` | Rounded rectangle, large |

### Transitions (arrows between M1 and M2)

| From | To | Label | Condition |
|------|----|-------|-----------|
| M1 | M2 | "Execution Readiness Gate passes" | All specs written, unknowns resolved, constraints pinned |
| M2 | M1 | "Design question surfaces" | Log in Now.md, stop building, switch mode |
| M2 | M1 | "Spec needs significant revision" | Proposed spec change too large for inline fix |

### DESIGN Zone Activities

| ID | Label | Description | Color |
|----|-------|-------------|-------|
| D1 | **Declare Layer** | System / Narrative / UI / Content / Economy / Scope | Yellow `#FFF3C4` |
| D2 | **One Active Question** | Diverge (options) then converge (decision) | Yellow `#FFF3C4` |
| D3 | **Perspective Pass** | View through player / designer / engineer / skeptic lens | Yellow `#FFF3C4` |
| D4 | **External Crosscheck** | Bring to ChatGPT/Gemini for stress test | Yellow `#FFF3C4` |
| D5 | **Write-Back Ritual** | Record decision in Decisions.md, update SettledDesign.md if established | Green `#D4EDDA` |

**Flow within DESIGN:** D1 → D2 → D3 (optional) → D4 (optional) → D5

### EXECUTION Zone Activities

| ID | Label | Description | Color |
|----|-------|-------------|-------|
| E1 | **Story Map** | User journey ordering, walking skeleton | Green `#D4EDDA` |
| E2 | **Behavioral Specs** | Human-authored, player-observable | Yellow `#FFF3C4` |
| E3 | **Red Team Spec** | Attack ambiguities before freeze | Purple `#E8DAEF` |
| E4 | **Spec Freeze** | Specs locked, changes need Decisions.md entry | Orange `#FFE0B2` |
| E5 | **Plan + Implement** | Builder agents execute, checkpoints gate progress | Green `#D4EDDA` |
| E6 | **Verify + Sign Off** | Tests green, acceptance criteria met, review complete | Pink `#FDEDEC` |

**Flow within EXECUTION:** E1 → E2 → E3 → E4 → E5 → E6

### Canon Documents (bottom row)

| ID | Label | Read by | Written by | Frequency | Color |
|----|-------|---------|------------|-----------|-------|
| DOC1 | **Now.md** | Every session start | Every session end | Constant | Blue `#D6EAF8` |
| DOC2 | **Decisions.md** | When needed | After every decision | Append-only | Blue `#D6EAF8` |
| DOC3 | **SettledDesign.md** | Session start, design checks | Write-back ritual only | When design becomes established | Blue `#D6EAF8` |
| DOC4 | **GamePillars.md** | Session start | Rarely (vision changes) | Stable | Blue `#D6EAF8` |
| DOC5 | **TDD.md** | Session start, planning | When architecture changes | Per deliverable | Blue `#D6EAF8` |
| DOC6 | **Learnings** | New project start | After crosscheck insights | Per learning | Blue `#D6EAF8` |

### Document read/write arrows

| Activity | Document | Action | Arrow style |
|----------|----------|--------|-------------|
| D2 (One Active Question) | DOC2 (Decisions.md) | Writes decision | Solid |
| D5 (Write-Back) | DOC3 (SettledDesign.md) | Updates if established | Solid |
| D5 (Write-Back) | DOC1 (Now.md) | Updates active question | Solid |
| D4 (Crosscheck) | DOC6 (Learnings) | Logs insight | Dashed |
| E1 (Story Map) | DOC5 (TDD.md) | Reads deliverables, may restructure | Solid |
| E2 (Behavioral Specs) | DOC5 (TDD.md) | Reads/writes acceptance criteria | Solid |
| E4 (Spec Freeze) | DOC2 (Decisions.md) | Logs any spec change | Solid |
| E6 (Sign Off) | DOC1 (Now.md) | Updates state | Solid |
| E6 (Sign Off) | DOC5 (TDD.md) | Updates if architecture changed | Dashed |

---

## Side Callouts

### Callout 1: Write-Back Contract (right margin of DESIGN zone)

```
WRITE-BACK CONTRACT (end of DESIGN session)
- Now.md updated (active question, mode, state)
- Decisions.md logged if tradeoff made
- SettledDesign.md patched only if ESTABLISHED
- TDD.md updated if architecture changed
- Learnings logged if crosscheck produced insight
```

### Callout 2: Execution Readiness Gate (between zones)

```
EXECUTION READINESS GATE
[ ] Acceptance criteria defined
[ ] Unknowns resolved or deferred
[ ] Constraints pinned
[ ] Behavioral specs written (human-authored)
```

### Callout 3: Mode Rules (top margin)

```
DESIGN: explore, one question at a time, layer discipline
EXECUTION: implement settled decisions, no ideation
Mixing modes is how projects get stuck.
```

---

## Annotations on arrows

| Arrow | Annotation |
|-------|-----------|
| DESIGN → EXECUTION | "Gate must pass" |
| EXECUTION → DESIGN | "Log question in Now.md first" |
| Any activity → Decisions.md | "Append-only, never edit past entries" |
| Crosscheck → Learnings | "Extract concepts, discard code" |
