# Recipe: Design Question Came Up During Implementation

## Situation

You're in EXECUTION mode building a feature, and you realize something isn't designed yet. Maybe the spec doesn't cover an edge case, or you discover two mechanics conflict.

## What to do

1. **Don't solve it inline.** Resist the urge to make a design decision while your head is in implementation. You'll make a fast, shallow call.

2. **Log it.** Add the question to Now.md's open questions with enough context to pick it up later:

   ```markdown
   ### [Layer name]
   - [The question, stated clearly] — came up while building [feature]. [1 sentence of context.]
   ```

3. **Keep building.** If you can stub around it (hardcode a value, skip the edge case, use a TODO), do that and move on. Mark the stub clearly.

4. **Switch modes later.** When you finish the current deliverable (or hit a blocker), switch to DESIGN mode and resolve the question properly — with layer declaration, options, and a decision log entry.

## Why this matters

Mixing modes is how projects get stuck. A "quick design decision" during implementation often contradicts something you settled earlier, and you don't notice until three files later. The 30 seconds to log it saves hours of rework.
