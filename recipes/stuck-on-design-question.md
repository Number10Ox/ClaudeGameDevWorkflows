# Recipe: Stuck on a Design Question

## Situation

You've been going back and forth on a design decision. Options keep multiplying. Nothing feels right. The conversation is getting long.

## What to do

1. **Check the layer.** Are you accidentally mixing layers? "How should the UI show doctrine changes" is a UI question. "What ARE doctrine changes" is a System question. If you're stuck, you might be trying to answer two questions at once. Split them and pick one.

2. **Run a perspective pass.** Look at the decision from different viewpoints (player, content creator, fellow dev, the game itself). Often the block is that you're optimizing for the wrong stakeholder. See [design-mode.md](../workflows/design-mode.md) for perspective details.

3. **Cross-check externally.** Open a conversation with ChatGPT or Gemini. Describe the decision (without code context) and ask for a different framing. Don't adopt their answer — bring the transcript back to Claude Code for assessment. See [llm-crosscheck.md](../workflows/llm-crosscheck.md).

4. **Prototype instead.** If you've been talking for more than 20 minutes without converging, stop designing and build a minimal version. Pick the simplest option, implement it, and play it. The answer often becomes obvious once you can see it running.

5. **Timebox and commit.** If none of the above unblocks you, pick the option that's easiest to change later, log it in Decisions.md with a "revisit if" trigger, and move on. Perfectionism on one decision blocks everything downstream.

## Signs you've been stuck too long

- You're on your third rewording of the same question
- You're generating more than 5 options
- The conversation is over 30 messages without a decision
- You keep saying "but what about..."
