---
name: quality-gate-name
description: "Use when [specific trigger]. Loads [domain] rules at point of use."
---

> **Adapt this:** Replace the name, description, trigger conditions, source docs, and review checks with your project's domain rules. The pattern (load rules → apply during work → review after) stays the same.

# Quality Gate: [Domain Name]

## On Invocation

1. Read the compiled checklist: [CHECKLIST.md](references/CHECKLIST.md)
2. Read your project's source doc(s) for this domain: `Docs/[relevant-spec].md`
3. All checklist rules are **hard constraints** during the work

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

## When to Use

- [Specific trigger 1]
- [Specific trigger 2]
- [Specific trigger 3]

## When NOT to Use

- [Activity that uses a different skill]
- [Activity that doesn't need this domain's rules]
