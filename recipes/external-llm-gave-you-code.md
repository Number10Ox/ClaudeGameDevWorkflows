# Recipe: External LLM Gave You Code

## Situation

You brainstormed with ChatGPT/Gemini and it generated schemas, TypeScript types, JSON structures, or implementation code for your game. It looks helpful. You're wondering whether to bring it into the project.

## What to do

1. **Don't paste it into your codebase.** The external LLM doesn't know your existing types, naming conventions, or architectural decisions. Its code will create a parallel system that conflicts with what you already have.

2. **Extract the concepts, discard the code.** Read through the generated code looking for *ideas* — a field you hadn't considered, a relationship between entities you hadn't modeled, a mechanic framing that's genuinely new. Write those down in plain language.

3. **Bring the concepts to Claude Code.** Describe what you found (not the code) and ask Claude Code to assess it against the existing codebase. "ChatGPT suggested tracking X as a per-agent property. Does that conflict with how we model agents in types.ts?"

4. **If you found something genuinely new,** log it as an open question in Now.md. Let it go through the normal design process — don't fast-track it because it came with code attached.

## Why external code is harmful

- **Different names for the same things** — `AgentRef` vs `AgentState`, `DoctrineDelta` vs `DoctrineEntry`
- **Hardcoded answers to open questions** — the LLM picks an answer you haven't decided yet
- **Re-introduces things you've already corrected** — it doesn't know your Decisions.md
- **Creates a parallel type system** — now you have two competing models of the same data

## What IS valuable from external LLMs

- Concept-level ideas (especially mechanics and narrative framing)
- Style/tone specifications (no codebase dependency)
- Alternative perspectives on a decision you're stuck on
- Names and terminology brainstorming

See [llm-crosscheck.md](../workflows/llm-crosscheck.md) for the full workflow.
