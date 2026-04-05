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

## The Fix

Convert process gates from behavioral suggestions into mechanical code paths.

Claude Code supports a skill system where invoking a skill forces file reads into context before generation begins. The spec isn't loaded because the model remembers to load it — it's loaded because the skill's execution path requires it. The read is a prerequisite in code, not a suggestion in prose.

The general principle: if you need an agentic LLM to reliably do X before Y, don't write "do X before Y" in a config file. Make X a prerequisite that executes automatically as part of Y's invocation. Treat process instructions the way you'd treat a CI pipeline — enforce them mechanically, don't rely on the developer (or the model) to remember.

## TL;DR

| Instruction type | Normal chat | Agentic mode |
|---|---|---|
| Output constraints ("never say X", "use term Y") | Works | Works |
| Process gates ("read spec before writing") | Works | **Fails silently** |

The fix isn't better prompting. It's moving process gates out of prose instructions and into mechanical enforcement — skills, hooks, pre-task scripts, anything that makes the prerequisite a code path rather than a behavioral suggestion.
