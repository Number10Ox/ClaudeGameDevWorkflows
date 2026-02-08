# Engineering Workflow (EXECUTION Mode)

Practices for implementing game features with Claude Code. Use this mode when working from settled design decisions, not when exploring or ideating.

> Sources: Boris Cherny (Claude Code creator), Anthropic team patterns, IndyDevDan (Tactical Agentic Coding), incident.io, personal experience.

---

## Deliverable Flow

Work in deliverables — discrete chunks with clear acceptance criteria.

### The Cycle

1. **"Start [deliverable]"** — begin planning
2. **Plan** — use plan mode or `/plan_with_team` to decompose into tasks
3. **Implement with checkpoints** — builder agents execute tasks, validator agents verify. For larger stories, define checkpoint gates (see below)
4. **"Sign off"** — triggers the sign-off checklist
5. **Move on** — start next deliverable

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

- [ ] **Acceptance criteria defined** — every deliverable has concrete, testable criteria (not "make it work")
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

> **Adapt this:** Replace these with your project's non-negotiable constraints.

Example (for a TypeScript game engine):
- [ ] No `any` types — use `unknown` + type guards
- [ ] Engine functions are pure (no side effects, no I/O)
- [ ] All game state is immutable — mutations return new objects
- [ ] Test plan covers every acceptance criterion
- [ ] Consistent with technical design doc
- [ ] Scoring/resolution is deterministic and auditable
- [ ] No classes for game logic — functions + interfaces only

---

## Deliverable Sign-Off Checklist

When the user says "sign off" or similar — run ALL of these:

- [ ] All acceptance criteria have passing tests
- [ ] Edge cases identified and tested
- [ ] No regressions: full test suite passes clean
- [ ] Technical design doc updated if architecture changed
- [ ] Critical code review: pass through all new/modified files checking for bugs, type safety, constraint adherence

> **Adapt this:** Add your project's specific checks — linting, coverage thresholds, build verification, etc.

---

## Verification Loop

The #1 tip for quality output (Boris Cherny): always give Claude a way to verify its work.

- After every implementation: run your test suite
- If tests fail: fix and re-run — closed loop until green
- Don't mark work as done until tests pass
- For behavioral claims: "Prove it works" — diff outputs or write a test that demonstrates the behavior

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

## Context Hygiene

- Use `/clear` when starting a new task — don't carry stale context
- Keep CLAUDE.md concise — it's read every session, so every line costs tokens
- Read your technical design doc at session start for architectural context
- If context is getting long, offload sub-tasks to subagents

---

## Environment Tips

- **Voice dictation:** fn fn on macOS. You speak 3x faster than you type, and prompts get more detailed.
- **Status line:** Use `/statusline` to always show context usage and current git branch
- **Permissions:** Use `/permissions` to pre-allow safe bash commands. Commit to `.claude/settings.json`.

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

## References

- [Boris Cherny's team tips thread](https://www.threads.com/@boris_cherny/post/DUMZr4VElyb)
- [incident.io: Shipping faster with Claude Code and Git Worktrees](https://incident.io/blog/shipping-faster-with-claude-code-and-git-worktrees)
- [IndyDevDan: Tactical Agentic Coding](https://agenticengineer.com/tactical-agentic-coding)
- [Spec-Driven Development with Claude Code](https://alexop.dev/posts/spec-driven-development-claude-code-in-action/)
- [Claude Code Best Practices (Anthropic)](https://www.anthropic.com/engineering/claude-code-best-practices)
- [The Task Tool: Agent Orchestration](https://dev.to/bhaidar/the-task-tool-claude-codes-agent-orchestration-system-4bf2)
