# Plan Quality Checklist

> Compiled reference for the plan skill. Each rule cites its origin doc; update this file when the source moves.
>
> **Adapt this:** Replace section C (project-specific code constraints) with checks that match your stack. The mandatory-section, gate, red-team, and quick-scan structure (A, B, D, E, and the bottom checklist) is generic.

---

## A. Mandatory Plan Sections

Every plan must include ALL of these sections. A plan missing any section is incomplete.

### A1. Goal
What is being built and why. 1-3 sentences.

### A2. Acceptance Criteria
Concrete, testable conditions for done-ness. The most commonly omitted section.
- Each criterion must be verifiable (can you check the box yes/no?)
- Cover: visual/behavioral, technical/build, modularity/architecture
- If a criterion says "feels right" or "looks good" — rewrite it with an observable condition

### A3. Pillar Alignment
Which game pillar(s) this deliverable serves. Reference `Docs/GamePillars.md`.
- If the plan can't name a pillar, question whether the work should be done

### A4. Execution Steps
Ordered implementation steps. Each step should be independently committable where possible.

### A5. Non-Goals
What this plan explicitly does NOT do. Prevents scope creep and sets expectations.

### A6. Design Spec Reference
The plan names the design spec it implements and states in one line what portion of the spec this plan covers. The spec must already exist as a file at one of:
- A living doc under `Docs/Design/<System>.md`
- A temporary working spec at `process/spec-<name>.md`

A plan without a spec reference is incomplete. A plan whose spec path does not resolve to a file is incomplete. A plan that builds something the spec does not describe is incomplete. *Origin: when planning happens without a unifying spec, terminology confusion and miscalibrated implementation choices follow — the plan ends up writing its own design under cover of being implementation work.*

---

## B. Execution Readiness Gate

Before execution begins, verify:

- [ ] Acceptance criteria exist and are agreed
- [ ] Plan exists as a file (not chat scroll)
- [ ] Pillar alignment stated
- [ ] Unknowns resolved or deferred
- [ ] Behavioral specs written (player experience, not function names)

---

## C. Plan Review Checks (project-specific — adapt)

> **Adapt this section** to your stack and architecture. Examples below; replace with your project's constraints.

### C1. Pillar alignment
Every mechanical change states which pillar it serves.

### C2. Architectural alignment
Check `Docs/Decisions.md` for applicable decisions. Verify the plan doesn't violate any.

### C3. Type discipline (example — adapt)
*Example for TypeScript projects:* No `any` types — use `unknown` + type guards.

### C4. Engine purity (example — adapt)
*Example for projects with an engine layer:* Engine functions are pure (no side effects in `src/engine/`).

### C5. Immutability (example — adapt)
*Example:* All game state is immutable.

### C6. Test coverage
Test plan covers every acceptance criterion.

### C7. Determinism (example — adapt)
*Example for games with scoring/simulation:* Scoring remains deterministic and auditable.

---

## D. Red Team Checks

Run BEFORE presenting the plan:

### D1. Ambiguity Scan
List every point where two engineers could read the spec and implement differently.

### D2. Minimal-Wrong-Pass Test
What's the minimal implementation that technically passes every AC but feels wrong?
If such an implementation exists, the spec has a gap. Fix it.

### D3. Contradiction Check
- Do any ACs contradict each other?
- Does the plan violate any decisions in `Docs/Decisions.md`?
- Do execution steps produce different results if reordered?

### D4. Cross-Reference Consistency
When the plan depends on a design spec, verify the spec sections the plan references are consistent with each other:
- Does the spec describe the same mechanism the same way in every section that mentions it?
- Do interface descriptions (inputs/outputs, call patterns) match the behavioral descriptions?
- **Per-feature doc check:** For each new UI surface or feature the plan introduces, identify and read the design doc governing that feature's content (not just the top-level system doc). Check the plan's ACs against that doc. *Origin: a top-level system doc rarely captures the per-feature content rules; reading only the system doc misses contradictions with the per-feature doc.*

### D5. Existing Implementation Audit
Before proposing to build any component, hook, helper, or system, grep the codebase for existing implementations of the same interfaces or patterns.
- For each "create new X" step: search for existing consumers of the same API/class/interface. If something already does the job under a different name, the plan should adapt it — not rebuild it.
- For each file the plan proposes to create: search for files that already serve the same purpose.
- Document findings: "X already exists at Y, doing Z" or "No existing implementation found."
- *Origin: plans that propose building "from scratch" components frequently duplicate code that already exists under a different name. A grep before writing the step would have found it.*

### D6. Pattern Transfer Without Shape Check
If the plan adopts a pattern from a predecessor or external project, the plan must show the shape comparison between predecessor artifact and current-project target.
- Predecessor artifact has shape X (participant structure, inputs, outputs, decision architecture).
- Current-project artifact has shape Y.
- The plan transfers which parts of X to Y, and which parts are derived-from-Y instead of imported-from-X?
- If the plan imports both the meta-principle AND the specific instantiation wholesale, flag **FIX**. Instantiation must derive from the current-project artifact's shape.

### D7. Implementation Completeness
Can an engineer implement every AC without inventing values, thresholds, or behaviors the spec doesn't provide?
- If the spec says "stats at extremes affect outcome" — does it give the thresholds?
- If the spec says "narrator tier determines behavior" — does it give the tier computation rules?
- If the plan references a call pattern — are the inputs, outputs, and error cases specified?
- **Verify concrete IDs.** For IDs referenced in the plan (beat IDs, fixture keys, entry IDs), grep the codebase to confirm they exist. A missing fixture entry is a crash, not an edge case.
- **Verify engine behavior under UI.** If the plan builds UI that renders engine state, verify that the engine behavior producing that state is tested — not just that the code path exists. Untested engine behavior is an incomplete spec for the UI layer.

### D8. Objective Correctness (if applicable)
- Off-by-one, division-by-zero, NaN propagation risks?
- Clamping at every point where values could escape bounds?
- What inputs would break the math?

### D9. Design Spec Coverage
- Does the plan's `## Design Spec` section name a file path?
- Does the file at that path exist?
- Does the spec describe what the plan proposes to build (not a related system, not a superset, not a superseded doc)?
- If any answer is no, flag **FIX**. A plan whose spec is missing or does not cover the build is a plan writing its own design under the cover of being an implementation plan.

---

## E. Behavioral Specs

Focus on player-observable behavior:
- **Good:** "When a beat choice appears, the handler sees A/B buttons with green/amber accent colors"
- **Bad:** "The BeatChoiceCard component renders TacticalButton with variant props"

### E1. Player experience first
Describe what the player sees and does, not internal implementation.

### E2. Spec freeze
Once execution begins, behavioral specs are frozen. Changes require explicit `Docs/Decisions.md` entry.

---

## Quick-Scan Checklist

Before presenting any plan, scan for these common omissions:

- [ ] Does the plan name a design spec that exists as a file, and does the spec cover what the plan builds? (no spec → plan is writing its own design)
- [ ] Are there acceptance criteria? (most common miss)
- [ ] Is pillar alignment stated?
- [ ] Are behavioral specs in player terms, not code terms?
- [ ] Does every AC have a clear yes/no verification method?
- [ ] Are non-goals stated?
- [ ] Has the red team been run?
- [ ] Has the hold-out reviewer been run (separate agent, no construction context)?
- [ ] Are unknowns explicitly flagged or resolved?
- [ ] Does the plan contradict any recent `Docs/Decisions.md` entries?
