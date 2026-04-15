# .claude/settings.json Template

> Copy the relevant sections to your project's `.claude/settings.json`.
> This file is committed to git and shared with the team.
> For personal overrides, use `.claude/settings.local.json` (gitignored).

---

## Hooks Configuration

Wire up lifecycle event hooks for audio notifications and process enforcement. See [hook templates](claude-hooks/) for the scripts.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/skill-guard.sh",
            "statusMessage": "Checking skill guard..."
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/stop.sh"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/subagent_stop.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/notification.sh"
          }
        ]
      }
    ]
  }
}
```

> **Adapt this:** The `skill-guard.sh` hook blocks writes to protected files unless the corresponding skill was invoked first. Edit the configuration variables at the top of the script to match your skill name and file pattern. See `claude-hooks/skill-guard.sh` for details.

## Permission Overrides (settings.local.json)

Personal permission overrides go in `.claude/settings.local.json` (not committed). Example:

```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(dotnet:*)",
      "Bash(npm:*)",
      "Bash(say:*)",
      "WebSearch"
    ],
    "deny": [
      "Bash(rm -rf /*)",
      "Bash(sudo:*)",
      "Bash(git push:*)"
    ]
  }
}
```

---

> **Adapt this:** The notification hooks are macOS-specific (using `say`). Replace the commands for your platform. The permission overrides depend on your project's toolchain.
