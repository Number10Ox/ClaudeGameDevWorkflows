---
name: doc-audit
description: "Use at milestone boundaries or when docs feel cluttered. Audits all markdown files for orphans, staleness, and superseded content. Produces a triage table."
allowed-tools: Read, Bash, Grep, Glob
---

> **Adapt this:** Update the directory list, archive paths, and cross-reference repos for your project.

# Doc Audit

Finds orphaned, stale, and superseded markdown files so you can decide what to archive.

## On Invocation

Run the audit across all configured directories. Present a triage table. The user decides what to archive — this skill discovers, it doesn't delete.

## Audit Steps

### 1. Discover all .md files

Glob for `**/*.md` in each configured directory. Exclude:
- `node_modules/`, `dist/`, `.git/`
- Archive directories (e.g., `Docs/Design/Archive/`, `process/archive/`, `Docs/deliverables/archive/`)

### 2. For each file, collect

- **Last modified:** `git log -1 --format="%ai" -- <file>`
- **Reference count:** Grep for the filename (without path) across the repo. Count files that reference it.
- **Summary:** Read first 5 lines for a one-line description.

### 3. Classify each file

| Category | Criteria | Action |
|----------|----------|--------|
| **Active** | Referenced by 1+ files AND modified in last 30 days | Keep |
| **Referenced but stale** | Referenced by 1+ files BUT not modified in 60+ days | Flag for review — content may be outdated |
| **Orphaned** | 0 references, modified in last 30 days | Flag — may be newly created, check if cross-refs are missing |
| **Stale orphan** | 0 references, not modified in 30+ days | Archive candidate |
| **Superseded** | A newer version exists (v2 when v3 exists, GoldenExample when GoldenScript exists) | Archive candidate |

> **Adapt this:** Adjust the day thresholds for your project's cadence. Fast-iterating projects might use 14/30 days. Slower projects might use 30/90.

### 4. Check for version supersession

Look for files with version suffixes (`-v1`, `-v2`, `-v3`) or known supersession patterns (e.g., `GoldenExample-*` replaced by `GoldenScript-*`). Flag older versions as superseded.

### 5. Decisions.md supersession integrity

Check that every supersession reference in the decision log has a matching forward pointer on the older entry, so a reader who lands on the older decision knows it was partially or fully superseded.

1. Grep the decision log (typically `Docs/Decisions.md`) for supersession patterns:
   - `Supersedes:` / `**Supersedes:**` lines (list form)
   - Prose mentions: `is superseded`, `superseded by D-`, `retired by D-`, `replaced by D-`
2. From each match, extract the *superseding* decision ID (the section the line lives in) and the *superseded* decision IDs referenced.
3. For each superseded D-###:
   - Locate that decision's section in the log (heading like `## D-###` or `### D-###`).
   - Check whether the section body contains any mention of the superseding ID.
   - If not, flag as **unmarked supersession** — the older entry has no forward pointer.
4. Suggest a forward-pointer blockquote under the older heading or a `Status: SUPERSEDED by ...` line on the Status field.

> **Adapt this:** If your project uses a different decision naming convention (ADR-###, RFC-###), adjust the regex accordingly.

### 6. Living doc implementation-status tag consistency

Living docs distinguish implemented sections (untagged) from ahead-of-implementation design (`[SPEC]` tag) — see `templates/living-doc-template.md` § Implementation Status Tags.

1. In your configured living-doc directories, grep for `^##.*\[SPEC\]` and `^###.*\[SPEC\]`. List every `[SPEC]`-tagged section.
2. For each `[SPEC]` section, note the section's age (last-modified via git). If older than 60 days, flag for review: "Has implementation caught up? If yes, remove the tag."
3. For each living doc that has code references (paths like `src/...` or named type symbols), quickly verify the referenced symbols still exist in the code. Flag broken references as drift.
4. Surface (without mechanical detection) a review prompt: "Look for sections that describe ahead-of-code behavior without a `[SPEC]` tag. Those need tagging — otherwise a new session will treat code as source of truth and lose the design."

### 7. Schema-duplication check in design docs

Design docs should point to code rather than re-state schemas. Grep for patterns that suggest duplication:

1. Find markdown tables in living docs where column headers include `Field`, `Type`, `Name`, or `Default`. These are schema-like tables.
2. Cross-reference against type definitions in code (e.g., `src/model/*.ts`). If a table's field names substantially overlap with a TypeScript type's fields, flag as **potential duplication candidate**.
3. Surface flagged cases for user review. The resolution is one of: replace the table with a code pointer, acknowledge as a human-view snapshot with a date, or tag the section `[SPEC]` if the doc is the source of truth for not-yet-coded schema.

### 8. Present triage table

Group by directory. For each file show:

```
| File | Category | Last Modified | Refs | Summary |
```

Separate into:
- **Archive candidates** (stale orphans + superseded) — recommend archiving
- **Needs attention** (referenced but stale, recent orphans) — user decides
- **Active** (for completeness, confirm nothing is miscategorized)

### 6. Cross-repo check (if configured)

If the project references files in other repos (vault, server, shared), check those references still resolve. Report broken cross-repo references.

## When to Run

- At milestone boundaries (before closing a milestone)
- When starting a new milestone (clean slate)
- When context feels sluggish (too many docs loaded)
- After any major doc reorganization
- Quarterly at minimum

## What This Skill Does NOT Do

- It does not archive or delete files. It presents findings for the user to triage.
- It does not assess content quality. Use `/doc-review` for that.
- It does not check CLAUDE.md or MEMORY.md bloat. That's a separate context hygiene concern (see CLAUDE.md rules).
