# Learnings

Cross-project observations that improve the workflows. When a project teaches you something about working with Claude Code on game dev, capture it here.

## Format

```markdown
## YYYY-MM-DD ([Project Name]): [One-line summary]

[2-5 sentences explaining what happened, what you learned, and how it changes the workflow.]

**Workflow impact:** [Which workflow or template should change, or "none — just awareness"]
```

## Entries

---

### 2026-02-07 (Context Drift): External LLM schemas are harmful

ChatGPT generated JSON schemas and TypeScript types for the game's data model without knowing the existing `OperationRun` canonical type. The result was a parallel type system with different names for the same concepts (`AgentRef` vs `AgentState`, `DoctrineDelta` vs `DoctrineEntry`). It also hardcoded answers to open design questions and re-introduced a field placement we'd explicitly corrected in the same session.

**Rule extracted:** If the external LLM's output requires knowing your codebase to be correct, discard it. Keep concept-level ideas, discard schemas and code. See [llm-crosscheck.md](../workflows/llm-crosscheck.md).

**Workflow impact:** Added "Filter aggressively" section to the LLM crosscheck workflow.

---

### 2026-02-07 (Context Drift): Style bibles are high-value crosscheck output

A ChatGPT conversation about narrative voice produced a style bible with tone rules, character limits, good/bad examples, and severity spectrums — all useful even without codebase context. The style bible was refined through Claude Code review (which caught missing elements like intel callbacks and cumulative tone degradation) and integrated into SettledDesign.md.

**Rule extracted:** Tone/voice specs are one of the highest-value outputs from external LLM brainstorming. They're pure design — no codebase dependency.

**Workflow impact:** Added "Style/tone specs" to the "Bring back" table in the LLM crosscheck workflow.

---

### 2026-02-07 (Context Drift): The discrepancy concept — best ideas come from filtering

ChatGPT proposed a `discrepancy` field where agent testimony contradicts the objective record. This was one genuinely new idea buried inside a 200-line schema we discarded. The concept (unreliable narrator at the data level) fits the antimemetic theme perfectly. Extracting it required reading through the noise.

**Rule extracted:** Good ideas from external LLMs come embedded in a lot of redundant/harmful output. The extraction step (bring transcript to Claude Code, assess against existing design) is where the value is created.

**Workflow impact:** Validates the crosscheck workflow pattern: external conversation → bring to Claude Code → extract/discard.
