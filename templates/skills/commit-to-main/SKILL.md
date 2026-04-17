---
name: commit-to-main
description: Complete a commit correctly for the current environment. In Claude Desktop worktree sessions (branch matches claude/* in a linked worktree), fast-forward merges into main. In direct sessions (Claude Terminal, VS Code, or any client on the main worktree), performs a normal commit. Invoked by "commit the worktree", "commit to main", or "snapshot and commit". Detects environment automatically.
---

# Commit (environment-adaptive)

Different clients produce different contexts:
- Claude Desktop → auto-spawned linked worktree on a `claude/*` branch
- Claude Terminal / VS Code / direct CLI → usually the main worktree on whatever branch the user chose

This skill completes a commit correctly for the current environment.

## When to invoke

- User says "commit the worktree", "commit to main", or "snapshot and commit".
- After `/snapshot` write-back if the user has asked for a commit.

## Step 1 — Detect environment

```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
LINKED=$([ "$(git rev-parse --git-common-dir)" != "$(git rev-parse --git-dir)" ] && echo 1 || echo 0)
if [ "$LINKED" = "1" ] && [[ "$BRANCH" =~ ^claude/ ]]; then
  MODE=worktree
else
  MODE=direct
fi
```

## Step 2 — Dispatch

### Mode: `direct`

Worktree ceremony doesn't apply.

1. Stage specific files (never `-A`).
2. Commit with a proper message per git commit guidance in CLAUDE.md.
3. If the user said "commit to main" specifically and the current branch is NOT `main`, stop and ask — they may have intended a merge, or may be on a feature branch on purpose.
4. Do not push to origin unless the user asks.

### Mode: `worktree`

Full Claude Desktop flow.

1. Stage specific files and commit in the worktree.
2. `MAIN_REPO=$(git worktree list | head -1 | awk '{print $1}')`
3. `cd "$MAIN_REPO"`.
4. If `git status --porcelain --untracked-files=no` is non-empty: `git stash push -m "pre-merge pending"` and record `STASHED=1`.
5. `git merge --ff-only "$BRANCH"`. On any failure, STOP and report. Do not rebase. Do not create a merge commit.
6. If stashed: `git stash pop`. On conflict, STOP and report the conflicted file list. Do not attempt automatic resolution.
7. If pop succeeded and re-applied edits are meaningful: commit them as a separate commit with its own message.
8. Verify: `git status` clean, `git log --oneline -5`, `git log --oneline origin/main..HEAD | wc -l` matches expectation.
9. Do NOT push to origin. Pushing is the user's manual step.

## What this skill does NOT do (either mode)

- Does not create pull requests.
- Does not push to `origin`.
- Does not clean up worktree branches or directories — Claude Desktop's Archive UI handles that.
- Does not run tests, typecheck, or build.
- Does not attempt to resolve merge or stash conflicts automatically.

## Scope notes

This skill encodes three policies:
1. Environment-adaptive: worktree ceremony only when actually in a Claude Desktop worktree.
2. Fast-forward-only merges (in worktree mode): no merge commits, no rebase on the session side.
3. Deferred push-to-origin: user pushes manually in either mode.

If any of those change, revisit the skill.
