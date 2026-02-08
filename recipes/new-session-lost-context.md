# Recipe: New Session, Lost Context

## Situation

You're starting a new Claude Code session. Claude doesn't remember what you were working on, what you decided, or where you left off.

## What to do

1. **Trust the docs.** If your CLAUDE.md has the session start protocol, Claude will read Now.md, SettledDesign.md, GamePillars.md, and your technical design doc automatically. That's enough to resume.

2. **Check Now.md first.** It should tell you:
   - What mode you're in (DESIGN/EXECUTION)
   - What question or task is active
   - What the current state is
   - What's explicitly out of scope right now

3. **If Now.md is stale,** update it before doing anything else. A 2-minute update saves a session of drift.

4. **If you're picking up mid-deliverable,** tell Claude: "I'm continuing [deliverable name]. Read the spec at `specs/[name].md` and the test results from last session." Give it a specific entry point, not a vague "where were we?"

## Prevention

End every session with the session wrap checklist (see [design-mode.md](../workflows/design-mode.md#session-wrap) or [execution-mode.md](../workflows/execution-mode.md#session-wrap)). If Now.md and Decisions.md are current, the next session starts clean.
