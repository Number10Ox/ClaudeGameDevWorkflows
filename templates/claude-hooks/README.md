# Hook Templates

Audio notification hooks for macOS. These use the `say` command to announce Claude Code lifecycle events via text-to-speech.

## Setup

1. Copy these scripts to your project's `.claude/hooks/` directory
2. Make them executable: `chmod +x .claude/hooks/*.sh`
3. Add hook configuration to `.claude/settings.json` (see [settings template](../settings-json.md))

## Scripts

| Script | Event | What it does |
|--------|-------|-------------|
| `notification.sh` | Notification | Announces when Claude needs attention (permission prompts, questions) |
| `stop.sh` | Stop | Announces when Claude finishes a response |
| `subagent_stop.sh` | SubagentStop | Announces when a subagent completes, with agent name |

## Platform

These scripts use macOS `say`. For Linux, replace with `espeak` or `spd-say`. For Windows, use PowerShell `[System.Speech.Synthesis.SpeechSynthesizer]`.
