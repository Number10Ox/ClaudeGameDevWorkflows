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

Devs and small teams building games with AI assistance. The workflows assume:
- You're doing both game design and engineering (or at least reviewing both)
- You want Claude to enforce process discipline, not just write code
- You're iterating over multiple sessions — this isn't a one-shot project
- You care about not losing design decisions between sessions

The workflow principles are the same whether you're solo or on a cross-disciplinary team. Teams add coordination norms (ownership, sign-offs, handoffs) on top of the same foundation — see [Team Considerations](workflows/execution-mode.md#team-considerations) in the engineering workflow.

## How to Use It

### Starting a new project

1. Copy `templates/claude-md.md` to your project as `.claude/CLAUDE.md`
2. Copy the document templates you need from `templates/` into your project's `Docs/` folder (start with Now.md, Decisions.md, GamePillars.md, and Roadmap.md — create living docs per system as needed)
3. Copy `templates/claude-commands/` into `.claude/commands/` and `.claude/agents/`
4. Copy `templates/claude-hooks/` into `.claude/hooks/` and wire up `templates/settings-json.md` as `.claude/settings.json`
5. Create `Docs/deliverables/` for D{N} acceptance and plan files
6. Adapt each file — look for `> **Adapt this:**` callout blocks
7. Reference `workflows/` for how the process works

### Referencing for an existing project

Read `workflows/` to understand the patterns. Cherry-pick what helps. You don't need all of it.

### Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add learnings, propose workflow changes, or add recipes.

## Contents

### Workflows

| File | What it covers |
|------|---------------|
| [workflows/design-mode.md](workflows/design-mode.md) | Game design process: layers, one-question discipline, write-back ritual, perspective passes |
| [workflows/execution-mode.md](workflows/execution-mode.md) | Engineering process: two flows (new system / evolution), plan-first, verification loops, sign-off checklists, parallel dev |
| [workflows/llm-crosscheck.md](workflows/llm-crosscheck.md) | When and how to use external LLMs (ChatGPT, Gemini) to stress-test your design |
| [workflows/ui-specification.md](workflows/ui-specification.md) | UI spec workflow: when to write specs, the implementation contract, verification process |
| [workflows/ui-testing.md](workflows/ui-testing.md) | UI testing pyramid: structural assertions, functional flows, visual regression — spec-driven, Claude-written |
| [workflows/build-discipline.md](workflows/build-discipline.md) | Response-level rules for execution: artifact-first format, drift headers, Three Anchors, pass isolation, validation discipline |
| [workflows/narrative-quality.md](workflows/narrative-quality.md) | Narrative quality framework: structural rules, voice rules, multi-narrator scoping, review gate |
| [workflows/constraint-audit.md](workflows/constraint-audit.md) | Periodic audit to prevent creative rule accumulation from producing compliance prose |
| [workflows/skill-authoring.md](workflows/skill-authoring.md) | How to create effective Claude Code skills: point-of-use principle, quality gate pattern |

### Templates

| File | Creates | Purpose |
|------|---------|---------|
| [templates/claude-md.md](templates/claude-md.md) | `.claude/CLAUDE.md` | Claude Code configuration — session start, constraints, style |
| [templates/now-md.md](templates/now-md.md) | `Docs/Now.md` | Tiny, always-current state snapshot |
| [templates/decisions-md.md](templates/decisions-md.md) | `Docs/Decisions.md` | Chronological decision log with rationale |
| [templates/living-doc-template.md](templates/living-doc-template.md) | `Docs/{SystemName}.md` | Per-system living doc — current reality for one system (recommended) |
| [templates/roadmap-md.md](templates/roadmap-md.md) | `Docs/Roadmap.md` | Forward-looking milestone tracker: current + next |
| [templates/settled-design-md.md](templates/settled-design-md.md) | `Docs/SettledDesign.md` | Monolithic game design doc (for small projects; see living docs for scaling) |
| [templates/game-pillars-md.md](templates/game-pillars-md.md) | `Docs/GamePillars.md` | Vision, pillars, anti-goals |
| [templates/tdd-md.md](templates/tdd-md.md) | `Docs/TDD.md` | Technical design document — architecture, subsystems, constraints, deliverables |
| [templates/screen-spec.md](templates/screen-spec.md) | `Docs/screen-spec-[name].md` | UI contract for a screen — layout, elements, data, states, navigation |
| [templates/settings-json.md](templates/settings-json.md) | `.claude/settings.json` | Hooks configuration, permission overrides |
| [templates/claude-hooks/](templates/claude-hooks/) | `.claude/hooks/` | Audio notification scripts (macOS TTS) for lifecycle events |
| [templates/claude-commands/](templates/claude-commands/) | `.claude/commands/` + `.claude/agents/` | Team orchestration, builder/validator agents |

### Recipes

Short, situational answers to common problems. See [recipes/README.md](recipes/README.md).

| Recipe | Situation |
|--------|-----------|
| [design-question-during-implementation](recipes/design-question-during-implementation.md) | A design question came up while you're building |
| [new-session-lost-context](recipes/new-session-lost-context.md) | Starting a new session and Claude doesn't remember anything |
| [stuck-on-design-question](recipes/stuck-on-design-question.md) | Going in circles on a design decision |
| [external-llm-gave-you-code](recipes/external-llm-gave-you-code.md) | ChatGPT/Gemini generated schemas or code for your project |

### Learnings

Cross-project observations that improve the workflows. See [learnings/README.md](learnings/README.md).

## Origin

Extracted from [Context Drift](https://github.com/jedwards/ContextDrift), a Mythos/SCP-themed containment game where AI agents use concept sequences to counter anomalies. The workflows were developed over multiple design and engineering sessions and battle-tested against real scope creep, decision loss, and AI-generated noise.

## Integrations

This playbook is tool-agnostic. If you use a deliverable execution tool (like [dev-workflow-assistant](https://github.com/Number10Ox/dev-workflow-assistant) for packet-based execution with drift tracking), the principles here define *what good looks like* while the tool enforces the mechanics.

## The Core Idea

Game development has two modes that need different processes:

**DESIGN mode** — exploring, ideating, deciding. Claude helps you generate options, narrow them, and record decisions. One question at a time. Layer discipline (don't mix system mechanics with UI layout). Write decisions back to docs before ending the session.

**EXECUTION mode** — implementing settled decisions. Claude plans, builds, and verifies. No ideation. If a design question comes up, log it and keep building. Plan first, then execute. Verify before signing off.

The two modes use the same document set but different workflows. Mixing them is how projects get stuck.

## License

MIT
