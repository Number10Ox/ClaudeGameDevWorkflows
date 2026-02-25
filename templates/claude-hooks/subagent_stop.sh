#!/bin/bash
# Announces when a subagent completes work via macOS TTS.
# Triggered by Claude Code's SubagentStop lifecycle event.
# Input: JSON payload on stdin with agent details.

# Read the event payload
INPUT=$(cat)

# Extract agent name if available, fallback to "Agent"
AGENT_NAME=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('agent_name', data.get('name', 'Agent')))
except:
    print('Agent')
" 2>/dev/null || echo "Agent")

say "${AGENT_NAME} complete." &
