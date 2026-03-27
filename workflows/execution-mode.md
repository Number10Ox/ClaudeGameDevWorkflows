# Engineering Workflow (EXECUTION Mode)

Practices for implementing game features with Claude Code. Use this mode when working from settled design decisions, not when exploring or ideating.

> Sources: Boris Cherny (Claude Code creator), Anthropic team patterns, IndyDevDan (Tactical Agentic Coding), incident.io, personal experience.

---

## Deliverable Flow

Work in deliverables — discrete chunks with clear acceptance criteria.

### The Cycle

1. **"Start [deliverable]"** — begin planning
2. **Plan** — write acceptance criteria and plan to deliverable files, or use `/plan_with_team` to orchestrate
3. **Red team** — attack the plan for ambiguities, underspecified behaviors, and minimal-wrong-pass implementations. Fix the plan before implementing.
4. **Implement with checkpoints** — builder agents execute tasks, validator agents verify. For larger stories, define checkpoint gates (see below)
5. **Code review** — structured review of all changed files (see Code Review below)
6. **"Sign off"** — triggers the sign-off checklist
7. **Move on** — start next deliverable

### Deliverable Files

Each deliverable gets its own files. These are the agreement surface — not the chat window, not a popup.

- **`Docs/deliverables/D{N}-acceptance.md`** — acceptance criteria, non-goals, open questions. Written during DESIGN mode, iterated in the editor, locked before EXECUTION starts.
- **`Docs/deliverables/D{N}-plan.md`** — implementation plan. Written after ACs are locked. Reviewed in the editor.

The D{N} numbering aligns with Decisions.md entries (D-001, D-002, etc.) for traceability. Acceptance criteria are the most important thing to agree on. Everything else follows from them.

> **Adapt this:** The `Docs/deliverables/` path and D{N} naming are conventions. Use whatever fits your project structure. The principle is: acceptance criteria and plans live in files the user can review in their editor, not in chat scroll.

### Checkpoints (for larger deliverables)

Don't shrink stories to reduce risk — add validation gates within them. Claude does not proceed past a checkpoint without you validating behavior.

Typical checkpoints:
1. **Plumbing compiles** — types, interfaces, and function signatures exist, project builds
2. **First playable loop** — the minimal path works end-to-end
3. **Edge cases handled** — failure states, empty states, boundary conditions
4. **Polish** — final UX, messaging, cleanup

> **Adapt this:** Your checkpoints depend on the deliverable. A UI story might gate on "renders with stub data" → "handles real data" → "handles errors." An engine story might gate on "pure function passes basic test" → "handles edge cases" → "deterministic under all seeds."

---

## Execution Readiness Gate

Before switching from DESIGN to EXECUTION mode, check that the slice is fully specified. If any of these fail, stay in DESIGN and resolve them first.

- [ ] **`D{N}-acceptance.md` exists and is agreed** — concrete, testable criteria in a file the user has reviewed (not "make it work")
- [ ] **`D{N}-plan.md` exists** — implementation plan written to a file, not a chat scroll
- [ ] **Architectural alignment verified** — plan cross-referenced against Decisions.md (or your equivalent decision log). Any architectural constraint that applies to this deliverable is explicitly addressed in the plan, not assumed. The user can't be expected to catch violations of decisions you already agreed on together — this is the AI's responsibility.
- [ ] **Unknowns resolved or deferred** — no open design questions block the implementation. Any that remain are explicitly logged and stubbed around
- [ ] **Constraints pinned** — project constraints (type safety, purity, determinism, etc.) are documented and non-negotiable
- [ ] **Behavioral specs written** — human-authored specs describing what the player experiences (see Story Mapping and Behavioral Specs below). These are the contract Claude implements against.

> **Adapt this:** The specific checks depend on your project. A narrative game might add "dialogue trees reviewed." A multiplayer game might add "networking assumptions validated." The principle is: EXECUTION should be able to run without design back-and-forth.

---

## Story Mapping

Story mapping organizes work by the player's journey, not by technical component. This prevents the most common AI-assisted dev failure: building technically correct systems that miss the user experience.

### How it works

1. **Identify personas** — who plays your game? What do they care about? (A completionist and a speedrunner experience the same game differently.)
2. **Map the journey horizontally** — walk through what the player does, step by step, across the full experience
3. **Slice vertically by priority** — the top row is the walking skeleton (thinnest playable path), lower rows add depth

```
Player Journey →
[Activity 1] → [Activity 2] → [Activity 3] → [Activity 4] → [Activity 5]
      ↓               ↓              ↓              ↓              ↓
Skeleton:  [minimal]   [minimal]     [minimal]      [minimal]      [minimal]
Enhance:   [richer]    [richer]      [richer]       [richer]       [richer]
Polish:    [full]      [full]        [full]         [full]         [full]
```

### Why this matters with AI

Claude defaults to technical decomposition ("build the engine, then the UI, then the data layer"). Story mapping forces user-journey decomposition ("build the thinnest path a player can walk through, then deepen it"). This produces playable slices earlier and catches UX problems before you've built a technically complete but experientially broken system.

### Where it lives

The story map is a DESIGN-mode artifact that bridges to EXECUTION. It can live in your technical design doc, in SettledDesign.md, or as a standalone `Docs/StoryMap.md` — wherever your deliverable breakdown lives. The map generates the deliverables, not the other way around.

> **Adapt this:** Your journey activities are game-specific. A roguelike maps: select loadout → enter dungeon → encounter rooms → boss → extract → upgrade. A narrative game maps: receive quest → explore → dialogue → choice → consequence → reflect.

---

## Behavioral Specs (Specification by Example)

Write behavioral specs before implementation. They describe what the player experiences in concrete terms — specification and test in one artifact.

### The principle

**Human writes the spec, Claude implements against it.** This is the natural division of labor: you define intent (what should happen from the player's perspective), Claude handles implementation (how to make it happen in code). The spec is the contract.

This replaces formal BDD/Gherkin ceremony with something lighter. A behavioral spec can be:
- Acceptance criteria concrete enough to be directly testable
- A test file that reads like a user flow (written by you, not Claude)
- A scenario in your technical design doc with specific inputs and expected outcomes

### What to specify

Focus on player-observable behavior, not implementation details:

- **Good:** "When all three protocols are BREACHED, the Case Summary banner says 'FULL BREACH' and the Unresolved section lists at least one open threat"
- **Bad:** "The `calculateOutcome()` function returns `{ status: 'breached' }` when all entries have `held: false`"

Claude writes unit tests for the implementation. You write behavioral specs for the experience. Both live in the codebase — the separation is authorship, not location.

### Invariants and property tests

Some game behaviors are better validated as rules that must always hold than as specific examples:

- **Invariants:** "Every STRESSED or BREACHED outcome has a non-empty cause" / "Score never increases when a protocol fails"
- **Property tests:** "For any valid input, the resolver produces exactly 3 outcomes" / "Resolution is deterministic — same seed always produces same result"

These complement behavioral specs. Examples validate specific journeys; invariants validate the system's physics. Both are human-authored.

### Spec freeze during EXECUTION

Once a slice enters EXECUTION, its behavioral specs are frozen. If Claude suggests changing the spec during implementation:

- Claude must present it as **"Proposed spec change"** with tradeoffs — not quietly update criteria
- Any change requires an explicit note in Decisions.md
- If the spec needs significant revision, stop and return to DESIGN mode

This prevents "boiled frog" design drift where the AI nudges you into accepting a slightly different interpretation across many small adjustments.

### Red-teaming your spec

Before Claude implements, ask it to attack the spec:

- "List ambiguity points in this spec"
- "What behaviors are underspecified?"
- "What's the minimal implementation that passes the spec but feels wrong to players?"

This keeps you as spec owner while using the AI to widen coverage. Fix the spec, then freeze it.

### Circular validation risk

When Claude writes both code and tests, the tests can match the implementation rather than the intent. Your behavioral specs are the countermeasure — they come from a different source (you) than the implementation (Claude). Review Claude's unit tests for whether they test the right thing, not just whether they pass.

> **Adapt this:** The level of formality depends on your project. For a solo prototype, acceptance criteria in your design doc might be enough. For a larger project, dedicated test files with scenario descriptions might be worth the investment. Don't add ceremony that doesn't earn its keep.

---

## Plan First, Then Implement

Start every complex task in plan mode. Pour energy into the plan so implementation can be one-shot.

- Use plan mode for anything touching multiple files or requiring design decisions
- Go back and forth until the plan is solid, then switch to auto-accept
- If something goes sideways mid-implementation, **stop and re-plan** — don't keep pushing
- For critical plans: spin up a subagent to review the plan "as a staff engineer"
- Use plan mode for verification steps too, not just the build

---

## Plan Review Checklist

Before presenting a plan for approval, self-review against your project's constraints.

- [ ] **Architectural alignment:** Search your decision log for all decisions that apply to this deliverable. Verify the plan doesn't violate any of them. This is not optional — the user can't be expected to catch violations of decisions you already agreed on together. This is the most common source of architectural drift in AI-assisted development: the decision was made, documented, and then forgotten during implementation.

> **Adapt this:** Replace the items below with your project's non-negotiable constraints.

Example (for a TypeScript game engine):
- [ ] No `any` types — use `unknown` + type guards
- [ ] Engine functions are pure (no side effects, no I/O)
- [ ] All game state is immutable — mutations return new objects
- [ ] Test plan covers every acceptance criterion
- [ ] Consistent with technical design doc
- [ ] Scoring/resolution is deterministic and auditable
- [ ] No classes for game logic — functions + interfaces only

---

## Code Review

After implementation and before sign-off, review all changed files against your project's coding style guide. This is mandatory for deliverables. For quick fixes (single-file, under 20 lines), a lighter pass is fine.

### Review format

Claude reviews by reading each changed file and checking against the project's code style rules and design system. Findings are reported inline:
- **FIX** — must resolve before sign-off (e.g., hardcoded font size, duplicated pattern)
- **WARN** — should resolve, acceptable to defer with a note (e.g., component slightly over size limit)
- **NOTE** — observation, no action needed (e.g., opportunity for future extraction)

If any FIX items are found, resolve them before proceeding to sign-off.

> **Adapt this:** Your checklist items are project-specific. Examples: no hardcoded colors (use design tokens), no duplicated patterns, type safety, immutability, semantic token usage, named constants for magic numbers.

---

## UX Reachability Check

For any deliverable that adds or changes UI, answer these before marking done:

1. **What does the player want to do?** (the user story in one line)
2. **Where are they when they want to do it?** (which screen/state)
3. **Can they get there without leaving the screen or knowing a hidden URL?**

If the answer to #3 is no, the feature isn't done — it needs a path from where the player already is.

---

## Deliverable Sign-Off Checklist

When the user says "sign off" or similar — run ALL of these:

- [ ] All acceptance criteria have passing tests
- [ ] Edge cases identified and tested
- [ ] No regressions: full test suite passes clean
- [ ] Technical design doc updated if architecture changed
- [ ] Code review passed — no outstanding FIX items (see Code Review above)
- [ ] UX reachability check passed (if UI-touching)
- [ ] Visual review passed (if UI-touching) — design system rules checked, screenshot requested from user

> **Adapt this:** Add your project's specific checks — linting, coverage thresholds, build verification, etc.

---

## Verification Loop

The #1 tip for quality output (Boris Cherny): always give Claude a way to verify its work.

- After every implementation: run your test suite
- If tests fail: fix and re-run — closed loop until green
- Don't mark work as done until tests pass
- For behavioral claims: "Prove it works" — diff outputs or write a test that demonstrates the behavior

### Run Reports

Tests validate correctness. Run reports validate quality. After a prototype run (playtest, simulation, season), write a structured report to disk for human review.

A run report captures **what happened** — not just whether it passed, but whether it felt right. This is especially important for games with emergent behavior, procedural systems, or AI-driven content where "all tests pass" doesn't mean "the experience is good."

**What belongs in a run report:**
- **Header:** mode, seed, config, run length — enough to reproduce the run
- **Turn-by-turn data:** world state, decisions made, events triggered, narrative output
- **Scorecard:** automated quality checks (target arc metrics, balance checks, pacing targets)
- **Outcome summary:** who won, how, final state

**When to generate:**
- Every prototype run should produce a report file
- Reports live in an `output/` directory (gitignored) — they're artifacts, not source
- The runner script handles report generation automatically; no manual step needed

**How to use:**
- Review reports to spot pacing issues, balance problems, or narrative quality gaps that tests can't catch
- Compare reports across seeds to verify variety and robustness
- Share reports with collaborators as concrete evidence of system behavior

See the [run report template](../templates/run-report.md) for the standard format.

### Sacred contract tests

Keep a small set (3-5) of tests that represent the game's identity. These run constantly and never break:

- Core loop completes (boot → meaningful choice → consequence → debrief)
- Failure state is understandable (player knows why they lost)
- Core loop repeats (can start a new round)

These are your walking skeleton tests. If they break, everything stops until they're fixed. They're the "is the game still a game?" check.

---

## Self-Correcting CLAUDE.md

When Claude makes a mistake and gets corrected:

1. Fix the immediate issue
2. Update CLAUDE.md with a rule to prevent the same mistake
3. Keep rules concise and actionable
4. Prune aggressively over time — remove rules that no longer apply

The mistake rate should measurably drop as rules accumulate.

---

## Parallel Development with Git Worktrees

Git worktrees let you check out multiple branches in separate directories, all sharing the same `.git` history. Each worktree gets its own Claude Code session.

### Why Worktrees

- **Parallelism:** One Claude implements feature A while another works on feature B
- **Isolation:** Sessions can't interfere with each other
- **Clean context:** Each session only sees changes relevant to its task
- **Easy comparison:** Test multiple approaches side by side

### Setup

```bash
# Create a worktree for a feature branch
git worktree add ../project-feature-name feature-name

# List active worktrees
git worktree list

# Remove when done (after merging)
git worktree remove ../project-feature-name
```

### Gotchas

- **Same-file edits:** Plan worktree boundaries around file ownership
- **Port conflicts:** Each worktree running a dev server needs different ports
- **Dependencies:** Install dependencies in each worktree separately

---

## Subagent Usage

- **Explore agents:** Codebase discovery, finding patterns, understanding existing code
- **Plan agents:** Architecture validation before implementation
- **General-purpose agents:** Multi-file refactors, complex research, web searches
- **Bash agents:** Running tests, builds, git operations in background
- Offload isolated tasks to subagents to keep the main context window clean

---

## Skills & Commands

Reusable workflows live in `.claude/commands/` and are committed to git.

- If you do something more than once per session, consider making it a command
- Examples: `/commit-push-pr`, `/plan_with_team`, tech debt finders, context-sync commands

---

## Prompting Patterns That Work

- **Challenge:** "Grill me on these changes and don't make a PR until I pass your test"
- **Prove:** "Prove to me this works" — have Claude diff behavior
- **Restart:** "Knowing everything you know now, scrap this and implement the elegant solution"
- **Spec first:** Write detailed specs and reduce ambiguity before handing work off
- **Hands-off bug fixing:** Paste an error or failing test and say "fix." Don't micromanage how.
- **Red team:** Before implementing, ask Claude to attack your spec: "List ambiguity points," "What's the minimal passing but wrong implementation?" Fix the spec first, then implement.

---

## Implementation Discipline

Rules that prevent common failures during rendering, UI, and complex system work. These are objective correctness checks, not aesthetic judgments.

### Research before trial-and-error

When working with unfamiliar APIs (3D rendering, shaders, physics, audio, platform-specific features), look up the correct approach before writing code. Wrong guesses compound — each failed attempt adds complexity that makes the next attempt harder. The user's time is more expensive than research time.

This applies to both web (Three.js, WebGL, Canvas) and Unity (shader graph, DOTS, addressables, platform APIs).

### File size guardrails

Propose splitting files at ~500 lines. When a file grows past this, it usually contains multiple concerns that should be separated. Common splits:
- Rendering helpers vs. React/MonoBehaviour component
- Data generation vs. runtime logic
- LOD/pooling vs. visual construction
- Constants/configuration vs. implementation

### Named constants with rationale

Critical parameters (dimensions, thresholds, ratios, material values) must be named constants with comments explaining **why**, not just what. This survives context loss across sessions.

```typescript
// BAD — magic numbers that get lost and reintroduced at wrong values
neons.push({ sx: w * 0.82, sy: h * 0.55 });

// GOOD — named, with rationale
const NEON_INSET = 0.82;   // recessed from wall face to create groove effect via bloom
const BRIGHT_BAND_H = 0.18; // thin accent, not solid block — 55% was too thick
```

For Unity C# projects, this overlaps with the "No tuning in code" data discipline rule — but applies even to values that aren't designer-tunable. If a value controls visual appearance, name it and explain it.

### Self-review for objective correctness

Before presenting a change, check:
- Does this preserve buffer/memory invariants? (instance counts, array bounds, pool sizes)
- Does this material/shader/effect actually compile and produce visible output?
- Does this produce the same output for the same input as the code path it replaces?
- Are there any off-by-one, division-by-zero, or NaN propagation risks?

These are verifiable checks that should never reach the user as a "try it and see" moment.

### One rendering path, not two

When the same data needs to render at different fidelity levels (LOD, quality settings, platform tiers), prefer a **single rendering function with a fidelity parameter** over two separate implementations. Divergent code paths rendering the "same" thing will inevitably fall out of sync — one gets fixed, the other doesn't.

### Automated screenshot capture for visual work

Visual iteration burns hours when the feedback loop requires manual screenshots. Before starting extended visual work, set up programmatic screenshot capture:
- **Web:** Playwright with `--use-gl=angle` or `--use-gl=swiftshader` for WebGL support
- **Unity:** `ScreenCapture.CaptureScreenshotAsTexture()` in batch mode, or custom editor script

This lets Claude iterate independently on objective failures (white screen, missing geometry, broken materials) without manual loops.

### Structured review handoffs

When a change needs external review (user, teammate, or external LLM like ChatGPT), produce a **review bundle** instead of requiring the reviewer to dig through the repo:
- The changed files (or relevant excerpts)
- A summary of what changed and why
- Specific questions for the reviewer
- Any context the reviewer needs that isn't obvious from the code

Format: single markdown file, temp directory with just relevant files, or clipboard-ready text.

---

## Context Hygiene

- Use `/clear` when starting a new task — don't carry stale context
- Keep CLAUDE.md concise — it's read every session, so every line costs tokens
- Read your technical design doc at session start for architectural context
- If context is getting long, offload sub-tasks to subagents

---

## Environment Tips

- **Voice dictation:** fn fn on macOS. You speak 3x faster than you type, and prompts get more detailed.
- **Status line:** Use `/statusline` to always show context usage and current git branch
- **Permissions:** Use `/permissions` to pre-allow safe bash commands. Commit to `.claude/settings.json`. See [settings template](../templates/settings-json.md).
- **Audio hooks:** Wire up TTS notifications for Stop, SubagentStop, and Notification events. See [hook templates](../templates/claude-hooks/).

---

## Session Wrap

Run this before ending any EXECUTION mode session. Takes 2-3 minutes.

- [ ] **Now.md current** — Active task reflects where you actually stopped. If mid-deliverable, note what's done and what's next
- [ ] **Design questions logged** — Any design questions that came up during implementation are in Now.md's open questions (not resolved inline)
- [ ] **Tests green** — If you made code changes, the test suite passes. Don't leave a session with failing tests if you can avoid it
- [ ] **Technical design doc updated** — If you changed architecture, data model, or interfaces, the doc reflects it
- [ ] **Commit** — All code and doc changes committed. Work-in-progress is fine as a commit — uncommitted changes are not

If you're mid-deliverable and stopping for the day, a short note in Now.md ("Finished tasks 1-3 of spec X, task 4 is next, tests green") is worth more than a perfect commit message.

---

## Team Considerations

The workflow principles above apply whether you're solo or on a cross-disciplinary team. What changes with teams is coordination, not philosophy.

### Spec ownership

Decide who can author and modify specs for each surface area. Design owns player-facing behavior and UX acceptance criteria. Engineering owns architecture, performance budgets, and test strategy. Narrative, art, and audio own their surfaces and constraints. Conflicts resolve via a Decisions.md entry with explicit tradeoffs — not by whoever edits the file last.

### Sign-off gates

Solo devs validate implicitly. Teams need explicit sign-off as part of the Execution Readiness Gate and the Deliverable Sign-Off Checklist. Keep it lightweight: a "Design-approved / Eng-approved / UX-approved" column in your deliverables table (or metadata in your execution tool) is enough. Don't build an approval workflow — just make it visible who has reviewed.

### Doc ownership

Canon docs (SettledDesign.md, Now.md, Decisions.md) need clear edit rights when multiple people touch them. A simple rule: anyone can propose changes, but the doc owner merges them. Now.md is owned by whoever is actively working. SettledDesign.md changes go through the write-back ritual. Decisions.md is append-only — anyone can add entries.

> **Adapt this:** The level of coordination overhead depends on team size. Two people might just talk. Five people need explicit ownership. Twenty people need a tool. Don't add process faster than you add people.

---

## AI Agent Roles

AI agents (subagents, worktree sessions, or [agent teams](https://code.claude.com/docs/en/agent-teams)) are collaborators with clear I/O contracts. They extend the builder/validator pattern to multi-agent coordination.

### The principle

**Agents propose, humans (or lead agents) decide.** An agent produces patch proposals, risk callouts, and validation results. It does not modify canon docs, merge to main, or change acceptance criteria without explicit approval. This matches the spec-freeze discipline: the spec is the contract, and no agent unilaterally changes the contract.

### Agent roles

- **Builder agent:** Implements against a spec. Outputs code + tests. Bounded by a deliverable or task.
- **Validator agent:** Read-only review. Checks implementation against acceptance criteria, constraints, and canon docs. Reports specific issues.
- **Red team agent:** Attacks a spec before implementation. Finds ambiguities, underspecified behaviors, minimal-passing-but-wrong implementations.
- **Reviewer agent:** Post-implementation. Checks patch against behavioral specs and invariants.

### Agent contracts (I/O boundaries)

When delegating to an agent — human-to-AI or AI-to-AI — define the contract:

- **Inputs:** Which files/components the agent reads or modifies
- **Outputs:** What artifacts it produces (code, tests, reports)
- **Invariants:** What must hold before and after (sacred contracts, project constraints)
- **Stop points:** Where the agent pauses for validation
- **Escalation:** What the agent can decide vs. what it must surface for human review

This makes AI-to-AI collaboration legible to humans. When a lead agent delegates to teammates, the contract is the same structure as a deliverable packet — bounded scope, clear acceptance criteria, explicit stop points.

> **Adapt this:** Solo devs use subagents informally. Small teams might formalize agent roles for parallel worktree development. Larger teams might use agent teams with a lead orchestrator. Scale the formality to the coordination cost.

---

## References

- [Boris Cherny's team tips thread](https://www.threads.com/@boris_cherny/post/DUMZr4VElyb)
- [incident.io: Shipping faster with Claude Code and Git Worktrees](https://incident.io/blog/shipping-faster-with-claude-code-and-git-worktrees)
- [IndyDevDan: Tactical Agentic Coding](https://agenticengineer.com/tactical-agentic-coding)
- [Spec-Driven Development with Claude Code](https://alexop.dev/posts/spec-driven-development-claude-code-in-action/)
- [Claude Code Best Practices (Anthropic)](https://www.anthropic.com/engineering/claude-code-best-practices)
- [The Task Tool: Agent Orchestration](https://dev.to/bhaidar/the-task-tool-claude-codes-agent-orchestration-system-4bf2)
- [Vercel: Introducing React Best Practices](https://vercel.com/blog/introducing-react-best-practices) — parallel data loading, lazy state initialization, request waterfall elimination
- [Vercel: AGENTS.md Outperforms Skills in Our Agent Evals](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals) — passive context (instruction files) beats active retrieval (agent-decided tool calls) for domain knowledge
