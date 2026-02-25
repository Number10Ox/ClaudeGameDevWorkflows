# .claude/settings.json Template

> Copy the relevant sections to your project's `.claude/settings.json`.
> This file is committed to git and shared with the team.
> For personal overrides, use `.claude/settings.local.json` (gitignored).

---

## Hooks Configuration

Wire up lifecycle event hooks for audio notifications. See [hook templates](claude-hooks/) for the scripts.

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/stop.sh"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/subagent_stop.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/notification.sh"
          }
        ]
      }
    ]
  }
}
```

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

> **Adapt this:** The hooks are macOS-specific (using `say`). Replace the commands for your platform. The permission overrides depend on your project's toolchain.
