#!/bin/bash
# llm-test-guard.sh — Block Bash commands that would make live LLM API calls
# without explicit user permission.
#
# PURPOSE: Keep autonomous / agentic workflows from burning tokens or hitting
# production API quotas on behalf of the user without them knowing. Live LLM
# tests are easy to start, slow to stop, and quietly expensive — a PreToolUse
# hard deny is the safest default.
#
# If a live LLM test is genuinely needed, Claude should ask the user first.
# There is no marker-file override in this template (by design). If the user
# decides overrides are warranted, add the marker pattern from skill-guard.sh.
#
# Scope: PreToolUse with matcher "Bash". Checks .tool_input.command against
# a list of patterns. If any match, denies with a message telling Claude to
# ask the user first.
#
# Coverage is best-effort. Common vectors covered: curl/wget to named LLM
# endpoints, CLI tool invocations (anthropic/openai/claude/gemini), scripts
# with obvious names. Not comprehensive — a determined workflow could route
# around this. Adapt the pattern list for your stack.
#
# ADAPT THIS:
# - BLOCKED_PATTERNS: regex per line. Blank lines and # comments ignored.
#
# Setup:
# 1. Copy to .claude/hooks/llm-test-guard.sh
# 2. chmod +x .claude/hooks/llm-test-guard.sh
# 3. Add to .claude/settings.json under PreToolUse with matcher "Bash"

# ── Configuration ────────────────────────────────────────────────────────────

# One regex per line. Lines starting with # are comments.
BLOCKED_PATTERNS='
# LLM provider API endpoints (HTTP)
# These are unambiguous — if the command contains the host, it is calling the API.
# Note: use api.anthropic.com (not bare anthropic.com) to avoid false-positives
# on the Co-Authored-By "noreply@anthropic.com" git trailer that Claude Code
# adds to commit messages.
api\.anthropic\.com
api\.openai\.com
api\.cohere\.(com|ai)
api\.mistral\.ai
generativelanguage\.googleapis\.com
api\.together\.xyz
api\.perplexity\.ai
api\.groq\.com
api\.deepseek\.com
api\.x\.ai

# Specific multi-token invocations that are unambiguous
# Avoiding bare CLI names (e.g., "anthropic") because developers commonly
# grep for those strings, which would false-positive.
(^|[[:space:]|;&])ollama[[:space:]]+run[[:space:]]
npx[[:space:]]+@anthropic-ai
npx[[:space:]]+openai
python[[:space:]]+-m[[:space:]]+openai
python[[:space:]]+-m[[:space:]]+anthropic

# NOTE on script-name patterns:
# Earlier versions of this template matched substrings like "llm-test" or
# "test-llm" to catch scripts that make LLM calls. Those patterns matched
# any string with those substrings — including file paths during cp/ls/grep —
# and caused far more false positives than true positives. Removed.
# If a script makes LLM calls, the endpoint patterns above should catch
# the actual API traffic; if it makes calls via a transport this hook does
# not cover, add a specific pattern for that transport here.
'

# ── Logic (no changes needed below) ─────────────────────────────────────────

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

MATCHED_PATTERN=""
while IFS= read -r pattern; do
  # Skip blank lines and comments
  [ -z "$pattern" ] && continue
  [[ "$pattern" =~ ^[[:space:]]*# ]] && continue

  if echo "$COMMAND" | grep -qE "$pattern"; then
    MATCHED_PATTERN="$pattern"
    break
  fi
done <<< "$BLOCKED_PATTERNS"

if [ -n "$MATCHED_PATTERN" ]; then
  jq -n --arg pattern "$MATCHED_PATTERN" --arg cmd "$COMMAND" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: ("BLOCKED: Command matches a live-LLM pattern (" + $pattern + "). Live LLM tests burn tokens, hit production quotas, and can produce silently confabulated results the user did not sign off on. Ask the user for explicit permission before running this command. If permission is granted for a one-off, the user can run the command directly; this hook is intentionally not overridable from within Claude.\n\nCommand: " + $cmd)
    }
  }'
  exit 0
fi

exit 0
