# Hook Templates

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

## Setup

1. Copy scripts to your project's `.claude/hooks/` directory
2. Make them executable: `chmod +x .claude/hooks/*.sh`
3. Add hook configuration to `.claude/settings.json` (see [settings template](../settings-json.md))
