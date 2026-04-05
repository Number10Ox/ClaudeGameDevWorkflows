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

### 5. Present triage table

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
