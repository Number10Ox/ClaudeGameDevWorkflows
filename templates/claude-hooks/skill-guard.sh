#!/bin/bash
# skill-guard.sh — Block writes to protected file patterns unless a skill was invoked first.
#
# PATTERN: Skill → Bash writes marker → Hook checks marker → Allow/Deny
#
# Problem: Process gates like "use /plan before writing plans" fail silently in
# agentic mode. The model reads the rule at session start but doesn't follow it
# at the moment of action. This hook enforces it deterministically.
#
# How it works:
# 1. The skill's first instruction tells Claude to run a Bash command that writes
#    a timestamp marker to /tmp/claude-skill-guard/<guard-name>
# 2. This hook fires on Edit|Write and checks for that marker
# 3. If the marker is missing or expired, the write is DENIED with a message
#    telling Claude to invoke the skill first
# 4. If the marker exists and is fresh, the write is ALLOWED (optionally with
#    additional context injected)
#
# ADAPT THIS:
# - Change GUARD_NAME to match your skill (e.g., "plan", "narration", "content")
# - Change FILE_PATTERN to match the files your skill protects
# - Change SKILL_NAME to match your skill's invocation name
# - Change MARKER_TTL_SECONDS for your session length (default: 4 hours)
# - Optionally add ADDITIONAL_CONTEXT for allowed writes (checklist reminders, etc.)
#
# Setup:
# 1. Copy to .claude/hooks/
# 2. chmod +x .claude/hooks/skill-guard.sh
# 3. Add to .claude/settings.json under PreToolUse with matcher "Edit|Write"
# 4. Add the marker-writing step to your skill's SKILL.md (see quality-gate template)

# ── Configuration ────────────────────────────────────────────────────────────

GUARD_NAME="plan"                          # Name for the marker file
FILE_PATTERN='process/plan-.*\.md$'        # Regex matching protected files
SKILL_NAME="/plan"                         # Skill invocation shown in deny message
MARKER_TTL_SECONDS=14400                   # 4 hours

# Optional: context injected when writes ARE allowed (leave empty to skip)
ADDITIONAL_CONTEXT="SKILL GUARD — You are editing a protected file.
Remember to run the review agent(s) before presenting to the user."

# ── Logic (no changes needed below) ─────────────────────────────────────────

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ "$FILE_PATH" =~ $FILE_PATTERN ]]; then

  STATE_DIR="/tmp/claude-skill-guard"
  MARKER="$STATE_DIR/${GUARD_NAME}_last_invoked"
  SKILL_INVOKED=false

  if [ -f "$MARKER" ]; then
    MARKER_TIME=$(cat "$MARKER")
    NOW=$(date +%s)
    AGE=$(( NOW - MARKER_TIME ))
    if [ "$AGE" -lt "$MARKER_TTL_SECONDS" ]; then
      SKILL_INVOKED=true
    fi
  fi

  if [ "$SKILL_INVOKED" = false ]; then
    jq -n --arg reason "BLOCKED: Use ${SKILL_NAME} skill before writing to this file. The skill loads required checklists, runs review agents, and ensures quality. Do NOT write protected files directly." '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $reason
      }
    }'
  elif [ -n "$ADDITIONAL_CONTEXT" ]; then
    jq -n --arg ctx "$ADDITIONAL_CONTEXT" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "allow",
        additionalContext: $ctx
      }
    }'
  else
    exit 0
  fi
else
  exit 0
fi
