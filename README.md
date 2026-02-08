# ClaudeGameDevWorkflows

Workflows and templates for building games with Claude Code as your design and engineering collaborator.

## What This Is

A set of practical workflows, document templates, and agent configurations for game development with Claude Code. Not a framework you install — a playbook you copy from and adapt.

These workflows solve specific problems that come up when using AI as a long-running collaborator on a game project:
- **Design drift between sessions** — the AI forgets what you decided
- **Mixing design and implementation** — ideation leaks into execution, causing rework
- **Layer confusion** — system mechanics, narrative, UI, and economy questions blur together
- **Lost decisions** — you discuss something, decide, then can't find why you decided it
- **External LLM noise** — ChatGPT gives you a schema that conflicts with your codebase

## Who It's For

Solo devs or small teams building games with Claude Code. The workflows assume:
- You're doing both game design and engineering (or at least reviewing both)
- You want Claude to enforce process discipline, not just write code
- You're iterating over multiple sessions — this isn't a one-shot project
- You care about not losing design decisions between sessions

## How to Use It

### Starting a new project

1. Copy `templates/claude-md.md` to your project as `.claude/CLAUDE.md`
2. Copy the document templates you need from `templates/` into your project's `Docs/` folder
3. Copy `templates/claude-commands/` into `.claude/commands/` and `.claude/agents/`
4. Adapt each file — look for `> **Adapt this:**` callout blocks
5. Reference `workflows/` for how the process works

### Referencing for an existing project

Read `workflows/` to understand the patterns. Cherry-pick what helps. You don't need all of it.

### Contributing learnings back

When a project teaches you something that improves the workflow, add it to `learnings/`. See `learnings/README.md` for format.

## Contents

### Workflows

| File | What it covers |
|------|---------------|
| [workflows/design-mode.md](workflows/design-mode.md) | Game design process: layers, one-question discipline, write-back ritual, perspective passes |
| [workflows/execution-mode.md](workflows/execution-mode.md) | Engineering process: plan-first, verification loops, sign-off checklists, parallel dev |
| [workflows/llm-crosscheck.md](workflows/llm-crosscheck.md) | When and how to use external LLMs (ChatGPT, Gemini) to stress-test your design |

### Templates

| File | Creates | Purpose |
|------|---------|---------|
| [templates/claude-md.md](templates/claude-md.md) | `.claude/CLAUDE.md` | Claude Code configuration — session start, constraints, style |
| [templates/now-md.md](templates/now-md.md) | `Docs/Now.md` | Tiny, always-current state snapshot |
| [templates/decisions-md.md](templates/decisions-md.md) | `Docs/Decisions.md` | Chronological decision log with rationale |
| [templates/settled-design-md.md](templates/settled-design-md.md) | `Docs/SettledDesign.md` | Single source of truth for current game design |
| [templates/game-pillars-md.md](templates/game-pillars-md.md) | `Docs/GamePillars.md` | Vision, pillars, anti-goals |
| [templates/claude-commands/](templates/claude-commands/) | `.claude/commands/` + `.claude/agents/` | Team orchestration, builder/validator agents |

### Learnings

Cross-project observations that improve the workflows. See [learnings/README.md](learnings/README.md).

## Origin

Extracted from [Context Drift](https://github.com/jedwards/ContextDrift), a Mythos/SCP-themed containment game where AI agents use concept sequences to counter anomalies. The workflows were developed over multiple design and engineering sessions and battle-tested against real scope creep, decision loss, and AI-generated noise.

## The Core Idea

Game development has two modes that need different processes:

**DESIGN mode** — exploring, ideating, deciding. Claude helps you generate options, narrow them, and record decisions. One question at a time. Layer discipline (don't mix system mechanics with UI layout). Write decisions back to docs before ending the session.

**EXECUTION mode** — implementing settled decisions. Claude plans, builds, and verifies. No ideation. If a design question comes up, log it and keep building. Plan first, then execute. Verify before signing off.

The two modes use the same document set but different workflows. Mixing them is how projects get stuck.

## License

MIT
