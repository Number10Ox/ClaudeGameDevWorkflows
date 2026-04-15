#!/bin/bash
# Session-start hook: injects Now.md + Roadmap (current & next milestone)
# so the model starts grounded in project state without relying on
# process-gate instructions it might skip.
#
# Why a hook, not a skill or CLAUDE.md instruction:
# "Read Now.md at session start" is a process gate. Process gates fail
# in agentic mode because the model is already committed to an execution
# trajectory before it processes the instruction. A hook fires before the
# model generates anything — no decision required, no gate to skip.
#
# Adapt: Change the file paths below to match your project's doc structure.
# Add or remove files based on what context you need at session start.
# Keep total output under 10K characters (hook output limit).

PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

# ---- CONFIGURATION ----
# Files to inject at session start. Order matters — most important first.
NOW_FILE="$PROJECT_DIR/Docs/Now.md"
ROADMAP_FILE="$PROJECT_DIR/Docs/Roadmap.md"
# -----------------------

CONTEXT=""

# Always inject Now.md — current state snapshot
if [ -f "$NOW_FILE" ]; then
  CONTEXT+="## Now.md
$(cat "$NOW_FILE")

"
fi

# Inject current + next milestone from Roadmap (skip completed/horizon)
if [ -f "$ROADMAP_FILE" ]; then
  ROADMAP_SECTION=$(sed '/^## Horizon\|^## Completed/,$d' "$ROADMAP_FILE")
  CONTEXT+="## Roadmap (current + next)
$ROADMAP_SECTION"
fi

if [ -n "$CONTEXT" ]; then
  jq -n --arg ctx "$CONTEXT" '{
    hookSpecificOutput: {
      hookEventName: "SessionStart",
      additionalContext: $ctx
    }
  }'
fi

exit 0
