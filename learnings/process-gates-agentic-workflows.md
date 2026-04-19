# Why Process Gates Fail in Agentic AI Workflows

## The Setup

Tools like Claude Code let you persist instructions in a `MEMORY.md` file that gets loaded into context every session. It's the main way you carry project knowledge, conventions, and workflow rules across conversations. And for most things, it works well.

But there's a category of instruction that fails reliably, and the failure is subtle enough that you might not notice it until the damage is done.

## What Works

Factual reference and output-time constraints:

- "The project is called Context Drift, not ContextDrift"
- "Use DRIFT not Leak when referring to the anomaly mechanic"
- "Never use body-part names in first-person agent narration"

These succeed because the model applies them **at generation time** — it checks them as it writes each token. They're filters on output. The model doesn't need to interrupt what it's doing to comply; it just shapes its output differently as it goes.

## What Fails

Process gates — instructions that require the model to stop, do something else, then come back:

- "Read `narrative-spec.md` before writing any dialogue"
- "Always check the style guide before generating prose"
- "Run the validation script before committing changes"

In a normal chat conversation, these work fine. The model processes the full system prompt before generating anything, so "do X before Y" naturally shapes the response from the start. There's no competing momentum.

Agentic mode is structurally different. The model is in an execution loop — planning steps, calling tools, writing files, running commands. When you give it a concrete task, the "do the thing" signal is extremely strong. A process gate requires the model to **interrupt its own execution trajectory**, go read a file it wasn't planning to read, integrate that content, and then resume. That's not an output filter — it's a workflow interrupt, and it competes directly against the task momentum the model has already built.

The instruction is in context. It's "seen." It just doesn't reliably trigger the interrupt because the model is already committed to a generation path. Making the instruction bolder, repeating it, or adding "THIS IS CRITICAL" doesn't change the underlying dynamic. I've watched this fail repeatedly with the note clearly visible in the context window.

## Why This Is Structural

In autoregressive generation, the model commits to a trajectory token by token. Once it's planning step 1 of a task, the behavioral priority is executing that plan. A meta-instruction saying "but first, stop and do this other thing" has to overcome that momentum, and it's the weakest category of in-context instruction precisely because it requires a temporal interruption rather than an output modification.

This isn't about context window size, instruction clarity, or prompt engineering skill. It's about the difference between two fundamentally different instruction types:

- **Output constraints** — applied continuously as the model generates. No interrupt needed.
- **Process gates** — require the model to stop its current plan, execute a prerequisite, then resume. Requires an interrupt.

The first type works in any context: system prompts, MEMORY.md, agentic workflows, wherever. The second type works in normal chat (where there's no execution momentum to interrupt) but fails in agentic mode (where there is).

## The Cross-Project Version

Everything above is within-session failure. There's a longer-horizon version that matters if you use LLM-assisted workflows across multi-project lifetimes: documented lessons decay when the next iteration starts.

Concrete form. Architecture decisions from three predecessor projects — a constraint-based voice framework, a structural narrator-prompt spec, a specific discipline for LLM prose generation — were referenced in the current project's `CLAUDE.md` under "Key Predecessor Decisions." Pointer lines. The files were accessible. Every session loaded the `CLAUDE.md` that referenced them.

Four project iterations in a row, the next narrator-prompt work regressed against the architecture those references pointed at. Each time, the project wrote a new prompt that didn't carry the predecessor's structural discipline. Each time, the regression surfaced only after live evaluation caught prose-quality failures. The failure has a name in our internal catalog: **B4, "Documenting Lessons Without Changing Behavior."** It's easy to recognize in retrospect; hard to prevent by documentation alone.

Why documentation fails even across sessions: a reference line in `CLAUDE.md` is read, but reading it doesn't connect it to an action. If the action is "write a new narrator prompt," the instruction "here's the predecessor architecture" produces no behavioral delta. The model reads the pointer, then proceeds to do what it would have done anyway — same structural shape as within-session process-gate failure, different time horizon.

The within-session fix — hooks that enforce invocation at the point of action — adapts here too. A file-path hook that requires a skill invocation, where the skill's first step is "read the predecessor architecture doc," converts the reference from a pointer into a load-bearing input. The reference wasn't doing any work because nothing mechanical forced it to. Same pattern; different scale.

The general form: any cross-session architecture you want preserved requires a mechanical gate at the point where it's about to be violated, not a reference line in a project-level doc.

## Fix Level 1: Skills

Convert process gates from behavioral suggestions into mechanical code paths.

Claude Code supports a skill system where invoking a skill forces file reads into context before generation begins. The spec isn't loaded because the model remembers to load it — it's loaded because the skill's execution path requires it. The read is a prerequisite in code, not a suggestion in prose.

The general principle: if you need an agentic LLM to reliably do X before Y, don't write "do X before Y" in a config file. Make X a prerequisite that executes automatically as part of Y's invocation. Treat process instructions the way you'd treat a CI pipeline — enforce them mechanically, don't rely on the developer (or the model) to remember.

## A Second Failure Mode: Taxonomy Drift

Skills fail for a different reason too, one not about invocation momentum. Skills only fire when the model (or a hook) *recognizes the work as belonging to the skill's scope*. That recognition is itself a categorization call — and categorization has gaps.

Concrete example from the project behind this doc. A `/narration` skill existed for roughly two cumulative years of cross-project work, scoped around "writing player-facing text" — mission beats, agent dialogue, feed lines. When it came time to edit the *prompt artifact that instructs the LLM how to write that text*, the skill didn't fire. Writing a narrator prompt isn't writing player-facing text. It's writing instructions for the LLM that will later write player-facing text. Different category. The skill's taxonomy had no slot for it.

The skill wasn't "skipped." It was never in consideration, because the work didn't match its recognized scope. The skill's rules didn't get deprioritized — the rules weren't considered to apply in the first place.

This is a different failure than the one in "What Fails." That one is about execution momentum overriding an in-context instruction. This one is about the gate never being connected to the work at all. Fix Level 1 solves the first failure. It doesn't touch the second — the model has no opportunity to forget to invoke a skill it never recognized as relevant.

The prescription: audit your skills for taxonomy coverage. For every category of work that has non-trivial constraints, ask: "If this work happens, does a skill recognize it?" Answers will surprise you. In our case, the skill's scope had been correct for two years of authoring prose and the gap only surfaced when the work shifted from prose to prompt artifact. The skill didn't regress — the surface area of the project grew past the skill's original taxonomy.

Note the implication: Fix Level 2 (file-path-matched hooks) addresses taxonomy drift *better* than skills alone, because the hook fires on a mechanical path match and doesn't rely on the skill's scope logic at all. This is a point in favor of adopting skill-guard hooks aggressively — they cover both the "forgot to invoke" failure and the "didn't recognize the category" failure with the same mechanism.

## Fix Level 2: Hooks That Enforce Skill Invocation

Skills solve the problem *once the model invokes them*. But the model still has to decide to invoke the skill — and that decision is itself a process gate. CLAUDE.md says "use `/plan` before writing plans." The model reads this at session start and then writes plans directly without invoking the skill. The instruction to use the skill suffers the same failure mode as the instruction the skill was created to enforce.

The fix: a **PreToolUse hook** that blocks writes to protected files unless the skill was invoked first.

### How the Skill Guard Works

Two pieces, forming a circuit:

1. **Hook (plan-guard.sh)** — fires on Edit|Write. When the model tries to write to a protected file pattern (e.g., `process/plan-*.md`), the hook checks for a timestamp marker file. If the marker is missing or expired, the write is **denied** with a message telling the model to invoke the skill. If the marker exists and is fresh, the write is **allowed**.

2. **Skill step 1** — the skill's first instruction tells the model to run a Bash command that writes the timestamp marker. When the model follows the skill, the marker gets written, and subsequent writes are unblocked.

### Why a Marker File

`Skill` is not a valid hook matcher — hooks can only match actual tools (Bash, Edit, Write, Read, etc.). Skills are prompt expansions, not tool invocations. So you can't directly detect "was `/plan` invoked?" from a hook. Instead, the skill's own instructions write a marker via Bash, and the hook checks for it.

### The Failure Mode Is Correct

If the model skips the skill's step 1 (the Bash command), the marker never gets written and writes remain blocked. This is the right outcome — if the model isn't following the skill's instructions, it shouldn't be writing to protected files.

### Limitations

- The marker expires (default: 4 hours). Long sessions may need to re-invoke the skill.
- If the model runs the Bash command without actually following the rest of the skill, the guard is bypassed. This is unlikely — the Bash command is step 1, and the skill's instructions are loaded into context as a unit.
- The hook fires on every Edit|Write to any file, but only checks files matching the pattern. There's no performance concern — the regex check is a single bash comparison.

### Template

The pattern is generic. See `templates/claude-hooks/skill-guard.sh` — configurable variables at the top: `GUARD_NAME`, `FILE_PATTERN`, `SKILL_NAME`, `MARKER_TTL_SECONDS`. Pair with the quality gate skill template (`templates/skills/quality-gate/SKILL.md`), which includes the marker-writing step.

### Recommendation: Adopt Skill-Guard by Default

Every non-trivial domain skill should have a skill-guard companion from the day the skill is written. Not when a failure surfaces. Day one.

Reasoning. Skills without guards rely on two things: (1) the model recognizes that the work falls under the skill's scope, and (2) the model decides to invoke the skill before acting. Both are LLM-judgment calls that fail silently — you won't notice they're failing unless you have independent signal on the output quality.

The `/narration` skill in the project behind this doc existed for roughly two cumulative years of cross-project work before its skill-guard was written. That whole time, its rules fired only when the model happened to invoke it. On the occasions when the model didn't — because the work was miscategorized (see "Taxonomy Drift" above), or because the model was in execution flow (see "What Fails" above) — the skill had zero effect. Nobody noticed, because the failure looked like "the model produced a sub-par output," not "the skill didn't fire."

The skill-guard pattern is cheap: one short shell script, a marker-writing step in the skill's `SKILL.md`, a line in `settings.json`. The cost of adopting it is lower than the cost of diagnosing its absence. The default should be: write the guard when you write the skill.

Exceptions exist — skills for lightweight convenience (e.g., a shortcut that generates a snippet) don't need mechanical enforcement. But any skill that encodes constraints the project cares about? Guard it.

## Fix Level 3: SessionStart Hooks for Context Injection

Skills and skill-guard hooks solve the *point-of-use* problem: when the model is about to write a plan, the hook forces the skill to load. But there's a category of process gate that doesn't have a natural trigger point: **session start reads**.

"Read Now.md and Roadmap.md at session start" is the most basic process gate in most projects. It was also the first one we wrote and the last one we caught — it survived multiple review passes of CLAUDE.md specifically looking for process gates. It survived because it *looks* like essential setup rather than a gate.

### Why the Session Start Skill Failed

We tried converting this to a skill (`skills/session-start/`). But the model still had to decide to invoke the skill at session start — which is itself a process gate. The instruction "invoke the session-start skill" suffers the same failure mode as the instruction it replaced.

### What Happened

The model was asked "what's next?" after completing a milestone. CLAUDE.md said "Read Roadmap.md when scoping new work." The model read Now.md (which said "Scope M6 (persistence)"), pattern-matched on the word "persistence," and answered from assumptions — never reading the roadmap. The roadmap said M6 was a *design* problem about how mission outcomes shape future missions. The model said it was technical infrastructure for save/load. The instruction was in context and was ignored.

### The Fix

A `SessionStart` hook that injects Now.md and the current/next milestones from Roadmap.md as `additionalContext` before the model generates anything. No decision required, no instruction to follow or skip. The content is just *there*.

```bash
# session-start.sh — fires on SessionStart event
# Reads Now.md + Roadmap (current & next milestone)
# Outputs JSON with additionalContext
```

See `templates/claude-hooks/session-start.sh` for the full template.

### The General Principle

If you need context loaded at session start, don't write "read X at session start" in CLAUDE.md. Use a SessionStart hook that injects the content automatically. Reserve CLAUDE.md for output constraints and factual reference — things the model applies as it generates, not things it needs to do before generating.

## What Mechanical Enforcement Can't Solve

Fix Levels 1–3 handle three categories of failure cleanly: point-of-use process gates, skill-invocation reliability, and session-start context loading. There's a fourth category that doesn't yield to any of them: **craft judgment at generation time.**

Examples:

- Is this sentence decorative (fills space without information) or necessary?
- Does this metaphor land, or is it a plausible-sounding confabulation?
- Is the rhythm of these three paragraphs varied enough, or monotonous?
- Is this character voice consistent with the agent's voice spec, or drifting toward a generic LLM register?

None of these are output-filterable — no single token triggers them, they emerge from sequences. None have a clean interrupt point — the model doesn't know it's about to fail, because the failures are pattern-level and visible only on re-read. A process gate that fires "check X before writing" doesn't help here, because X is a judgment the model doesn't possess.

This is the category where the user must remain the catch. An LLM-assisted workflow doesn't eliminate this failure mode; it re-positions where the catching happens. The user moves from "write the prose" to "review the prose." The review is load-bearing: without it, pattern-level failures accumulate invisibly, session after session, and eventually produce output that is technically compliant with every rule and creatively dead.

The honest version of the process-gate story is that mechanical enforcement solves the categorizable parts of the problem and leaves the judgment parts to the user. The temptation — which is itself a failure mode — is to keep adding rules, skills, and hooks in the hope of eventually automating judgment. That approach produces *compliance-shaped output*: technically correct, creatively dead. Our internal failure-modes catalog names this pattern the "Add a Rule" Reflex, and it is the most persistent of the meta-failures because it looks productive.

The correct conclusion isn't that agentic workflows can't do craft work. It's that craft work demands a specific division of labor: mechanical enforcement for the structural parts, human review for the judgment parts. Skipping the latter because the former scaled is how you end up with prose that parses and says nothing.

## TL;DR

| Instruction type | Normal chat | Agentic mode | Fix |
|---|---|---|---|
| Output constraints ("never say X", "use term Y") | Works | Works | None needed |
| Process gates ("read spec before writing") | Works | **Fails silently** | Skill (loads rules at point of use) |
| Skill invocation ("use /plan before writing plans") | Works | **Fails silently** | Skill-guard hook (blocks writes without skill) |
| Session-start reads ("read Now.md at start") | Works | **Fails silently** | SessionStart hook (injects content automatically) |
| Work outside a skill's recognized scope (taxonomy drift) | Depends | **Fails silently** | Audit skill coverage; add modes or new skills for uncovered work categories; prefer file-path hooks over skill-scope categorization |
| Predecessor architecture across project iterations | Works when manually consulted | **Fails silently** | File-path hook + skill whose first step is "read the predecessor doc"; pointers in CLAUDE.md don't survive |
| Craft judgment at generation time (decorative? rhythm? voice drift?) | Depends on model | Depends on model | **No mechanical fix** — user review remains load-bearing |

The fix for the upper five rows isn't better prompting. It's moving process gates out of prose instructions and into mechanical enforcement — skills for loading rules, hooks for enforcing skill invocation, SessionStart hooks for context injection, and file-path-scoped guards for work that a skill's scope doesn't recognize.

The fix for the last row is that there is no fix. Craft judgment remains with the user. A workflow that claims otherwise is selling compliance as if it were quality.

The strongest default-on prescription: **every non-trivial domain skill gets a skill-guard the day it's written.** Skills without guards are unreliable in ways you won't notice until an external evaluation catches what should have been caught internally.
