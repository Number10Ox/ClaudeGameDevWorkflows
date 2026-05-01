---
name: plan
description: Use when writing an implementation plan for a deliverable. Loads the plan review checklist, execution readiness gate, and red team spec at point of use. Ensures acceptance criteria, pillar alignment, and architectural alignment are present before the plan is considered complete.
argument-hint: [plan-name]
---

> **Adapt this:** Replace the placeholder doc paths in the source-doc list (engineering workflow, pillars, decisions log) and the example incident citations with your project's actual files. The shape of the skill — pre-spec gate, mandatory sections, red team, hold-out review — stays the same. The "Why X exists" notes inline cite the kinds of failures this skill prevents; replace them with your own once you have a few examples in your project.
>
> **Pair with:** `claude-hooks/skill-guard.sh` (configured for plan files) so the skill must be invoked before writing to `process/plan-*.md` or your equivalent path. The marker step in "On Invocation" completes the circuit.

# Plan Skill

Loads engineering workflow constraints into active context so they are enforced at plan-writing time, not just session-start time.

## On Invocation

1. **FIRST: Write the plan-guard marker** so the hook allows plan file writes:
   ```
   mkdir -p /tmp/claude-plan-enforcement && date +%s > /tmp/claude-plan-enforcement/plan_skill_last_invoked
   ```
   Run this via Bash BEFORE any other step. Without it, the plan-guard hook will block all writes to `process/plan-*.md`.

   > **If not using a plan-guard hook:** remove this step. The marker is only meaningful when paired with the hook.

2. Read the compiled checklist: [CHECKLIST.md](references/CHECKLIST.md)
3. Read your project's engineering workflow doc (e.g., `Docs/Workflow/workflow-engineering.md`) for the full execution readiness gate, plan review checklist, and red team spec
4. If writing a new plan, create the file at `process/plan-<name>.md` (use `$ARGUMENTS` for the name)
5. If reviewing an existing plan, read the plan file first

## Pre-writing Spec Check

Before writing any plan, the deliverable must have an existing design spec. **A plan implements a spec — it does not replace one.** Plans without specs become plans that quietly invent design decisions under the cover of being implementation work.

Ask the user which spec this plan implements. Accept one of:

- **Existing living doc** — a file in `Docs/Design/<System>.md`. Confirm the file exists and covers the deliverable this plan will implement.
- **Temporary working spec** — a file at `process/spec-<name>.md`. If it does not exist yet, the user writes it first (or the next turn is a spec-writing turn, not a plan-writing turn). The working spec can be terse, but it must name the system, its inputs and outputs, and what a correct implementation produces. It becomes the system's living doc after implementation if the system is new.
- **Extension of an existing living doc** — plan extends a system already documented. Reference the living doc; the plan's own `## Design Spec` section names the section(s) it extends.

If none of these are available, stop. Do not write the plan. Report to the user that a spec is required first, and offer to help draft a working spec at `process/spec-<name>.md`.

The spec path becomes the value of the plan's mandatory `## Design Spec` section (see Writing Mode step 3 below).

## Writing Mode (default)

When invoked before writing a plan (default, or `/plan <name>`):

1. Every item in CHECKLIST.md is a hard constraint while composing the plan
2. Write the plan to `process/plan-<name>.md`
3. **MANDATORY sections** — the plan is incomplete without all of these:
   - Design Spec (path to the spec file; one line naming what portion of the spec this plan implements)
   - Goal (what and why)
   - Acceptance criteria (concrete, testable — the most common omission)
   - Pillar alignment (which game pillar(s) this serves — see `Docs/GamePillars.md`)
   - Execution steps
   - Non-goals
4. **MANDATORY: Run BOTH review agents** in parallel on the plan BEFORE presenting to the user:
   - **Red team agent** (see Red Team Mode) — structured D1-D8 checks
   - **Hold-out reviewer** (see Hold-Out Review) — holistic read, no checklist
   Self-checking is necessary but NOT sufficient. These steps are never optional.
5. Fix all FIX results from both agents
6. Present the plan to the user with any EDGE findings noted
7. Tell the user the file path so they can open it in their editor

## Red Team Mode

When invoked after writing (or `/plan review`):

Launch a `general-purpose` Task agent. The agent must:

1. Read the plan file
2. Read your project's engineering workflow doc (red team spec section)
3. Read `Docs/GamePillars.md` — verify pillar alignment claim
4. Read `Docs/Decisions.md` (tail — last 50 lines) — check for contradictions with recent decisions
4b. **Verify Design Spec exists and covers the plan.** Read the file at the path in the plan's `## Design Spec` section. If the path does not resolve to a file, flag **FIX**. If the spec does not describe what the plan proposes to build (spec talks about system X, plan builds system Y), flag **FIX** — the plan is building something the spec does not call for.
5. **Identify per-feature design docs.** For each new UI surface or feature the plan introduces, identify the design doc that governs that feature's content/behavior (not just the top-level system doc). Read it. *Example: if the plan adds an intel feed UI, read the IntelModel doc, not just the top-level MissionScript doc — the per-feature doc is where the feature's content rules live.*
6. **Existing implementation audit.** For each component/system the plan proposes to build, grep the codebase for existing implementations of the same interfaces. Document: "X already exists at Y" or "No existing implementation found."
6a. **Predecessor-pattern shape check.** If the plan references a predecessor or external project as a pattern source, you MUST load a current-project artifact that demonstrates the TARGET BEHAVIOR, not only the top-level design doc. Examples:
   - Plan adopts narrator-prompt architecture from predecessor → load a current-project narrator/prompt file to see this project's beat / output shape. Compare against predecessor's reference shape.
   - Plan adopts judge/evaluator architecture from predecessor → load the current project's evaluator code AND its rendered output artifacts.
   - Plan adopts narrative-voice rules from predecessor → load a shipped piece of content (fixture / golden example) in the current project.

   Record a shape comparison: "Predecessor artifact has shape X (participant structure, inputs, outputs, decision architecture). Current-project artifact has shape Y. The plan's proposed adoption transfers which parts of X to Y, and which parts are derived-from-Y instead of imported-from-X?" If the plan imports BOTH the meta-principle AND the specific instantiation wholesale, flag as **FIX** — instantiation must derive from the current-project artifact's shape, not be copied from elsewhere.
7. Run the three red team checks:
   - **Ambiguity scan:** List every point where two engineers could implement differently
   - **Minimal-wrong-pass test:** What's the minimal implementation that technically passes every AC but feels wrong?
   - **Contradiction check:** Do any ACs contradict each other? Does the plan violate any settled decisions? Do any ACs contradict the per-feature design docs identified in step 5?
8. **Verify concrete references.** For IDs referenced in the plan (beat IDs, fixture keys, entry IDs, template fields), grep the codebase to confirm they exist. A missing fixture entry is a crash, not an edge case.
9. Tag each finding: **FIX** (must resolve), **EDGE** (add test case), **OK** (examined, no issue)

**Exit criteria:** Zero FIX results. EDGE results noted in the plan.

## Hold-Out Review

Launch a SECOND `general-purpose` Task agent **in parallel** with the red team agent. This agent gets NO construction context — only the finished artifact and reference docs.

The agent must:

1. Read the plan file
2. Read the design spec the plan depends on (path in the plan's `## Design Spec` section). If the plan has no `## Design Spec` section, or the path does not resolve to a file, flag **FIX** immediately — the plan cannot be reviewed without its spec.
3. Read `Docs/GamePillars.md`
4. Read `Docs/Decisions.md` (tail — last 50 lines)
4a. **Current-project artifact check.** If the plan proposes to change an artifact whose correct output is already demonstrated somewhere in the current project (fixtures, golden examples, shipped content, prior working implementation), load that demonstration artifact. Read it. Compare its shape against whatever reference pattern the plan claims to adopt. If the plan adopts a predecessor shape that does not match the current-project demonstration, flag as **FIX**. *This check exists because design-doc reading alone misses shape mismatches that only surface when you read the implementation artifact.*
5. Read the plan holistically — no checklist, no prescribed checks. Find:
   - Internal contradictions (mechanisms that conflict with each other)
   - Rationale mismatches (explanations that don't match what the mechanism actually does)
   - Incomplete specifications (where an implementer would have to guess or invent). If the plan builds UI that renders engine state, verify the engine behavior producing that state is tested — not just that the code path exists. Untested engine behavior is an incomplete spec for the UI layer.
   - Gaps in coverage (variants, combinations, or paths that aren't addressed)
   - Unnecessary complexity (is there a simpler version of each mechanism that produces the same results? e.g., a parameter that appears in two places when one would suffice, or a mapping function where fixing the source type would eliminate it)
   - Pre-existing behavior interaction (does the plan account for what the code already does? If the runner already processes X, and the plan adds Y that also touches X, what happens when both fire?)
6. Tag each finding: **FIX** (must resolve), **EDGE** (add test case), **OK** (examined, no issue)

**Why this exists:** The structured red team (D1-D8) catches category-specific issues. The hold-out reviewer catches issues that don't fit any category — contradictions visible on a plain reading, rationale that doesn't match the mechanism, incomplete tables. A plan can pass the structured red team but still have issues that are obvious on a holistic external read.

**What makes it "hold-out":** The agent receives ONLY the plan and reference docs. No construction history, no previous drafts, no design rationale, no red team findings. Task agents don't inherit conversation context, so this isolation is automatic.

**Exit criteria:** Zero FIX results. EDGE results noted in the plan alongside red team EDGE items.

## Completeness Check

Before presenting the plan, verify against the execution readiness gate:

- [ ] Design Spec section present, path resolves to an existing file, spec covers what the plan builds
- [ ] Acceptance criteria exist and are concrete/testable
- [ ] Pillar alignment stated
- [ ] Unknowns resolved or explicitly deferred
- [ ] Behavioral specs written (what the player experiences, not internal function names)
- [ ] Plan written to a file, not chat scroll

If any item is missing, add it before presenting.

## Why This Skill Exists

Engineering workflows commonly mandate acceptance criteria as step 1 of the deliverable flow, but this requirement doesn't survive to plan-writing time. The rule gets read at session start but not enforced at the moment of action. This skill loads the constraints at point of use so they actually shape the plan, then runs two independent reviewers (one structured, one holistic) because self-checking after writing has a poor track record at catching the writer's own blind spots.
