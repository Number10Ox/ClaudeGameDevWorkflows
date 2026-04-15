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

## Fix Level 1: Skills

Convert process gates from behavioral suggestions into mechanical code paths.

Claude Code supports a skill system where invoking a skill forces file reads into context before generation begins. The spec isn't loaded because the model remembers to load it — it's loaded because the skill's execution path requires it. The read is a prerequisite in code, not a suggestion in prose.

The general principle: if you need an agentic LLM to reliably do X before Y, don't write "do X before Y" in a config file. Make X a prerequisite that executes automatically as part of Y's invocation. Treat process instructions the way you'd treat a CI pipeline — enforce them mechanically, don't rely on the developer (or the model) to remember.

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

## TL;DR

| Instruction type | Normal chat | Agentic mode | Fix |
|---|---|---|---|
| Output constraints ("never say X", "use term Y") | Works | Works | None needed |
| Process gates ("read spec before writing") | Works | **Fails silently** | Skill (loads rules at point of use) |
| Skill invocation ("use /plan before writing plans") | Works | **Fails silently** | Hook (blocks writes without skill) |
| Session start reads ("read Now.md at start") | Works | **Fails silently** | SessionStart hook (injects content automatically) |

The fix isn't better prompting. It's moving process gates out of prose instructions and into mechanical enforcement — skills for loading rules, hooks for enforcing skill invocation, and SessionStart hooks for context injection.
