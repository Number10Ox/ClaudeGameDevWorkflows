#!/bin/bash
# Stop hook: injects design write-back reminder before Claude stops.
#
# Non-blocking — just adds context. The model decides whether action is needed.
# If design decisions were made and not written back, the model should
# run /snapshot or update the living doc before finishing.
#
# Setup:
#   1. Copy to .claude/hooks/stop-snapshot-reminder.sh
#   2. chmod +x .claude/hooks/stop-snapshot-reminder.sh
#   3. Add to .claude/settings.json:
#      "Stop": [{ "hooks": [{ "type": "command",
#        "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/stop-snapshot-reminder.sh" }] }]
#
# Pair with: skills/snapshot/SKILL.md for full write-back checklist.
#
# Why a hook instead of a CLAUDE.md instruction?
# "When a design decision is made, update the living doc" is a process gate.
# Process gates fail silently in agentic mode — the model is executing a plan
# and doesn't interrupt itself to check meta-instructions. Hooks fire on tool
# events regardless of what the model is doing. This hook ensures the reminder
# is always delivered at the point of action.
# See: learnings/process-gates-agentic-workflows.md

cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "Stop",
    "additionalContext": "BEFORE STOPPING: Were design decisions made or revised this session that are not yet in the active living doc? If yes, update the living doc now or run /snapshot. If no design work happened, proceed."
  }
}
EOF
exit 0
