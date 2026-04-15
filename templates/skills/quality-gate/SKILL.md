---
name: quality-gate-name
description: "Use when [specific trigger]. Loads [domain] rules at point of use."
---

> **Adapt this:** Replace the name, description, trigger conditions, source docs, and review checks with your project's domain rules. The pattern (load rules → apply during work → review after) stays the same.

# Quality Gate: [Domain Name]

## On Invocation

1. **FIRST: Write the skill-guard marker** so the enforcement hook allows protected file writes:
   ```
   mkdir -p /tmp/claude-skill-guard && date +%s > /tmp/claude-skill-guard/[guard-name]_last_invoked
   ```
   Run this via Bash BEFORE any other step. Without it, the skill-guard hook will block writes to protected files. See `claude-hooks/skill-guard.sh` for the enforcement hook.

   > **If not using the skill-guard hook:** Remove this step. The marker is only needed when paired with `skill-guard.sh` to enforce that the skill is invoked before writing to protected files.

2. Read the compiled checklist: [CHECKLIST.md](references/CHECKLIST.md)
3. Read your project's source doc(s) for this domain: `Docs/[relevant-spec].md`
4. All checklist rules are **hard constraints** during the work

## Writing Mode (default)

When invoked before doing the work:

1. Load the checklist — every item is a constraint while working
2. Do the work
3. **Launch a review agent** (see Mandatory Review below)
4. Fix all FAIL results before presenting to the user

## Mandatory Review

After the work is done, launch a `general-purpose` Task agent. The agent must:

1. Read the output/artifact
2. Re-read all source docs from disk (fresh context — not recalled from the writing session)
3. Check every line against every rule in the checklist
4. Report **PASS / FAIL / WARN** per rule

**Exit criteria:** Zero FAIL results. WARN results noted.

> **Why a separate agent?** The writer's context normalizes its own violations. A fresh reader with the same rules catches what the writer skips. Self-checking is necessary but not sufficient.

## Enforcement (optional but recommended)

Pair this skill with `claude-hooks/skill-guard.sh` to enforce that the skill is invoked before writing to protected files. Without enforcement, the model reads the "use this skill first" instruction at session start but skips it at the moment of action.

**Setup:**
1. Copy `skill-guard.sh` to `.claude/hooks/`
2. Edit the configuration variables at the top: `GUARD_NAME`, `FILE_PATTERN`, `SKILL_NAME`
3. Add to `.claude/settings.json` (see settings template)
4. The marker step above (On Invocation step 1) completes the circuit

**How it works:**
- Hook fires on Edit|Write → checks for timestamp marker → blocks if missing
- Skill step 1 writes the marker via Bash → subsequent writes are allowed
- Marker expires after configurable TTL (default: 4 hours)

## When to Use

- [Specific trigger 1]
- [Specific trigger 2]
- [Specific trigger 3]

## When NOT to Use

- [Activity that uses a different skill]
- [Activity that doesn't need this domain's rules]
