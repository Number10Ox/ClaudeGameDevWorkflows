# Hook Templates

## Context Injection Hooks

Hooks that inject project context into the model's context window at lifecycle boundaries. These replace process-gate instructions ("read X at session start") that fail silently in agentic mode.

| Script | Event | What it does |
|--------|-------|-------------|
| `session-start.sh` | SessionStart | Injects Now.md + Roadmap (current & next milestone) at session start. Replaces "Session Start" instructions in CLAUDE.md. |

**Why a hook, not a CLAUDE.md instruction:** "Read Now.md at session start" is a process gate — it requires the model to interrupt its execution trajectory to do a prerequisite. In agentic mode, this fails silently. The hook fires before the model generates anything, injecting the content with no decision required. See `learnings/process-gates-agentic-workflows.md`.

**Why a hook, not a skill:** The session-start skill (in `skills/session-start/`) had the same problem — the model had to decide to invoke it, which is itself a process gate. The hook removes the decision entirely.

## Notification Hooks

Audio notification hooks for macOS. These use the `say` command to announce Claude Code lifecycle events via text-to-speech.

| Script | Event | What it does |
|--------|-------|-------------|
| `notification.sh` | Notification | Announces when Claude needs attention (permission prompts, questions) |
| `stop.sh` | Stop | Announces when Claude finishes a response |
| `subagent_stop.sh` | SubagentStop | Announces when a subagent completes, with agent name |

**Platform:** These scripts use macOS `say`. For Linux, replace with `espeak` or `spd-say`. For Windows, use PowerShell `[System.Speech.Synthesis.SpeechSynthesizer]`.

## Process Enforcement Hooks

Context injection and blocking hooks that fire on tool events. These address the process gate problem — instructions like "use /plan before writing plans" fail silently in agentic mode because the model doesn't interrupt its execution trajectory. Hooks fire deterministically regardless of what the model is doing.

| Script | Event | What it does |
|--------|-------|-------------|
| `skill-guard.sh` | PreToolUse (Edit\|Write) | **Blocks** writes to protected files unless the corresponding skill was invoked first. Configurable: file pattern, skill name, marker TTL. Pair with `skills/quality-gate/`. |
| `plan-guard.sh` | PreToolUse (Edit\|Write) | **Blocks** plan-file writes on two gates: (1) skill-invocation check, and (2) REQ-XX-### citation check. Forces requirements to be captured before plans that depend on them can land. Pair with `workflows/design-mode.md` § Requirements Capture. |
| `llm-test-guard.sh` | PreToolUse (Bash) | **Blocks** Bash commands that match live-LLM patterns — provider API endpoints (anthropic.com, api.openai.com, etc.) and specific CLI invocations (`ollama run`, `npx @anthropic-ai/...`, `python -m openai`). Hard deny — no override marker — because live LLM tests are easy to start, slow to stop, and quietly expensive. Adapt the pattern list for your stack. |
| `stop-snapshot-reminder.sh` | Stop | Injects reminder to check for unwritten design decisions before ending. Pair with `skills/snapshot/` |

### Skill Guard Pattern

The `skill-guard.sh` hook solves a specific failure mode: the model reads "use /plan before writing plans" at session start, then writes plans directly without invoking the skill. The hook enforces the gate deterministically.

**How it works:**
1. The skill's first instruction tells Claude to write a timestamp marker via Bash
2. The hook fires on Edit|Write, checks for that marker
3. If missing or expired → **DENY** with message to invoke the skill
4. If present and fresh → **ALLOW** (optionally with additional context)

**Setup:**
1. Copy `skill-guard.sh` to `.claude/hooks/`
2. Edit configuration at the top: `GUARD_NAME`, `FILE_PATTERN`, `SKILL_NAME`, `MARKER_TTL_SECONDS`
3. Add the marker-writing step to your skill's SKILL.md (see `skills/quality-gate/` template)
4. Register in `.claude/settings.json` (see [settings template](../settings-json.md))

**Limitations:**
- `Skill` is not a valid hook matcher — hooks cannot detect skill invocations directly
- The marker is written by a Bash command in the skill's instructions, not by the hook system
- Relies on Claude following the skill's first instruction (but if it skips that, the hook catches it)

See `learnings/process-gates-agentic-workflows.md` for why this category of hook exists.

### Plan Guard Pattern

`plan-guard.sh` layers a second gate on top of the skill-guard pattern: plan files must cite at least one requirement ID (`REQ-XX-###`).

**Why:** Plans without requirement cites drift into purposeless scope. The hook forces the author to either reference an existing requirement from a living doc's `## Requirements` section, or capture the requirement *before* writing the plan. Requirements therefore become a prerequisite of planning, which is where they belong.

**How it works:**
1. Gate 1 (same as skill-guard): `/plan` skill must have been invoked recently.
2. Gate 2 (new): the content being written must contain a string matching `REQ-[A-Z]+-[0-9]+` (configurable).
3. If either gate fails → **DENY** with a message directing the author to the missing step.

**Configuration:** See the header of `plan-guard.sh`. Default settings match the conventions described in `workflows/design-mode.md` § Requirements Capture.

**Pairs with:**
- `workflows/design-mode.md` § Requirements Capture — defines where requirements live and how they're numbered
- `templates/living-doc-template.md` — per-system living doc that carries the `## Requirements` section
- The `/plan` skill — writes the marker file that satisfies Gate 1

### LLM Test Guard Pattern

`llm-test-guard.sh` is a standalone blocker on Bash commands that would make live LLM API calls. No skill integration, no marker file — a hard deny.

**Why no override:**
- Live LLM tests are easy to start and slow to stop. Kicking one off without the user knowing can burn real money or quota.
- Silent confabulation risk: a live LLM test produces output that looks plausible. Without the user asking for it, they can't judge whether the output is what they wanted.
- If a test is genuinely needed, the user can run the command themselves. The agent has no legitimate reason to bypass.

**Coverage:** Pattern list covers common vectors:
- Provider API endpoints (`anthropic.com`, `api.openai.com`, `api.cohere.com`, `api.mistral.ai`, `generativelanguage.googleapis.com`, etc.)
- Specific multi-token CLI invocations (`ollama run`, `npx @anthropic-ai/...`, `python -m openai`, `python -m anthropic`)

Not exhaustive — adapt `BLOCKED_PATTERNS` for your stack.

**What it doesn't catch:**
- Code that makes LLM calls when executed (Python / Node scripts with embedded API keys that dial an endpoint the script-source does not expose in the bash command). If a script makes API calls, the endpoint pattern typically catches the actual traffic when the script runs. If you use a bundled client that hides the endpoint, add the client's invocation pattern to `BLOCKED_PATTERNS`.
- Indirect routes (e.g., a local proxy to an LLM). If you use those, add them to `BLOCKED_PATTERNS`.
- Bare LLM-related words as grep/cp/ls targets: an earlier version matched `anthropic` / `llm-test` / `test-llm` as standalone substrings, but that produced far more false positives (file path operations, code searches) than true positives. Those patterns were removed. If you want them back for a specific project, add them locally with project-specific context that reduces the FP rate.

## Setup

1. Copy scripts to your project's `.claude/hooks/` directory
2. Make them executable: `chmod +x .claude/hooks/*.sh`
3. Add hook configuration to `.claude/settings.json` (see [settings template](../settings-json.md))
