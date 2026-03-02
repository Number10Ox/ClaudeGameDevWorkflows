# Run Report Template

> Standard format for prototype run reports. Adapt the sections to your game's systems.
> Reports are generated automatically by the runner script and saved to `output/` (gitignored).

---

```markdown
══════════════════════════════════════════════════
  [PROJECT NAME] — RUN REPORT
══════════════════════════════════════════════════
  Mode: [mock | api | playtest]
  Turns: [number of turns completed]
  Seed: [PRNG seed for reproducibility]
  Config: [key tuning parameters that affect this run]
══════════════════════════════════════════════════

──────────────────────────────────────────────────
  TURN [N]
──────────────────────────────────────────────────

WORLD STATE:
  [Per-zone or per-entity state snapshot — whatever your game tracks]
  [Include enough to understand the situation without reading code]

GLOBAL: [Top-level meters, scores, or aggregate state]

--- DECISIONS ---

[What agents/players/systems chose this turn]
[Include: who, where, what action, what outcome]
[If AI-generated: include the reasoning or strategy summary]

--- EVENTS ---

[Significant state changes triggered by the turn resolution]
[Threshold crossings, phase changes, cascades, etc.]

--- NARRATIVE ---

[If your game has narrative output, include it here]
[Bulletin, vignettes, dialogue, flavor text — whatever the player would see]

[State strip or HUD summary line]

--- END OF TURN [N] ---

══════════════════════════════════════════════════
  RUN RESULT
══════════════════════════════════════════════════

[Outcome: who won, how, final state summary]
[Scoreboard: per-faction or per-player final standings]

══════════════════════════════════════════════════
  SCORECARD
══════════════════════════════════════════════════

Target Arc Score: [X/Y]

- [PASS | FAIL] [Metric 1 — what it checks]
- [PASS | FAIL] [Metric 2 — what it checks]
- [PASS | FAIL] [Metric 3 — what it checks]

[Detailed metrics: timing data, balance ratios, pacing measurements]
```

---

## Usage Notes

**Sections to adapt:**
- **World State:** Replace zone/entity format with your game's state model
- **Decisions:** Replace with your game's action/choice system (missions, card plays, dialogue choices, etc.)
- **Events:** Replace with your game's significant state transitions
- **Narrative:** Optional — only if your game produces narrative output
- **Scorecard:** Define 3-5 target arc metrics that define "a good run" for your game

**Naming convention:**
```
report-{mode}-s{seed}-t{turns}-{ISO-timestamp}.md
```

**Target arc metrics examples:**
- Pacing: "First dramatic event by turn X"
- Balance: "No faction/player leads by more than 2:1 at midpoint"
- Escalation: "Crisis/tension metric reaches threshold Y by turn Z"
- Variety: "At least N distinct event types fire per run"
- Completion: "Run reaches natural conclusion (not timeout)"

**Implementation:**
- Build a `formatReport()` function that takes your run data and produces this markdown
- Build a `writeReport()` function that saves to `output/` with the naming convention
- Wire both into your runner script so every run produces a report automatically
- Add `output/` to `.gitignore` — reports are artifacts, not source
