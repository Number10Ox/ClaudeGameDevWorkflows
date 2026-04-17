#!/bin/bash
# plan-guard.sh — Enforce two gates on plan files:
#
#   Gate 1: the /plan skill must have been invoked recently
#           (same mechanism as skill-guard.sh)
#   Gate 2: the plan must cite at least one requirement ID (REQ-XX-###)
#
# PURPOSE: Make requirements traceable through plans into execution.
#
# If a plan can't cite a requirement, either the requirement doesn't exist
# yet (capture it in the relevant system's living doc first) or the plan
# doesn't have a clear purpose. Either way, the plan should not land.
#
# The REQ-XX-### convention is defined in workflows/design-mode.md
# § Requirements Capture. Each system's living doc carries a ## Requirements
# section with numbered, append-only entries the plan can cite.
#
# ADAPT THIS:
# - FILE_PATTERN: regex matching your plan files
# - SKILL_NAME: the skill that must be invoked (default "/plan")
# - MARKER_TTL_SECONDS: how long a skill invocation stays "fresh" (default 4h)
# - REQ_REGEX: pattern for your requirement IDs
#   Default 'REQ-[A-Z]+-[0-9]+' matches REQ-MG-001, REQ-CM-003, etc.
# - REQ_CHECK_TOOL: "Write" only checks brand-new plan files (recommended).
#   "Write|Edit" also checks edits (strict — rejects edits that don't reinsert
#   a cite, which is usually the wrong behavior).
# - ADDITIONAL_CONTEXT: optional checklist reminder injected on allowed writes
#
# Setup:
# 1. Copy to .claude/hooks/plan-guard.sh
# 2. chmod +x .claude/hooks/plan-guard.sh
# 3. Add to .claude/settings.json under PreToolUse with matcher "Edit|Write"
# 4. Ensure your /plan skill writes the marker file on invocation
#    (see templates/skills/quality-gate for the marker-writing pattern)

# ── Configuration ────────────────────────────────────────────────────────────

FILE_PATTERN='process/plan-.*\.md$'
SKILL_NAME="/plan"
MARKER_TTL_SECONDS=14400
REQ_REGEX='REQ-[A-Z]+-[0-9]+'
REQ_CHECK_TOOL="Write"

# Optional: context injected when writes ARE allowed (leave empty to skip).
# Good for project-specific checklist reminders (e.g., "verify concrete IDs").
ADDITIONAL_CONTEXT=""

# ── Logic (no changes needed below) ─────────────────────────────────────────

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ ! "$FILE_PATH" =~ $FILE_PATTERN ]]; then
  exit 0
fi

# Gate 1: skill invocation check
STATE_DIR="/tmp/claude-skill-guard"
MARKER="$STATE_DIR/plan_last_invoked"
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
  jq -n --arg skill "$SKILL_NAME" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: ("BLOCKED: Use " + $skill + " skill before writing plan files. The skill loads the checklist, runs review agents, and ensures plan quality. Do NOT write plan files directly.")
    }
  }'
  exit 0
fi

# Gate 2: REQ-citation check
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

if [[ "$TOOL_NAME" =~ ^(${REQ_CHECK_TOOL})$ ]]; then
  # Extract content: Write uses .content, Edit uses .new_string
  CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // empty')
  if ! echo "$CONTENT" | grep -qE "$REQ_REGEX"; then
    jq -n --arg regex "$REQ_REGEX" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: ("BLOCKED: Plan must cite at least one requirement ID matching pattern " + $regex + ". Plans should reference requirements from the relevant system'"'"'s living doc (## Requirements section). If no requirements exist yet for the area this plan covers, capture them in the living doc first, then return to write the plan. See workflows/design-mode.md § Requirements Capture.")
      }
    }'
    exit 0
  fi
fi

# Allowed — inject optional context
if [ -n "$ADDITIONAL_CONTEXT" ]; then
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
