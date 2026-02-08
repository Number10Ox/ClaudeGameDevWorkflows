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

---

### 2026-02-07 (Context Drift): Human writes the spec, AI implements against it

StrongDM's "dark factory" article proposed keeping test scenarios separate from code as "holdout sets" to prevent circular validation. Initial reaction was to create a new `scenarios/` folder outside the codebase. On reflection, this misses the point — BDD-style behavioral specs already solve this problem when the **human writes the spec and Claude implements against it**. The separation that matters is authorship, not location.

Story mapping (user journey → walking skeleton → deliverables) and behavioral specs (specification by example, test-first) are pre-AI practices that are MORE important with AI, not less. Claude defaults to technical decomposition and can write tests that match its own implementation. Human-authored behavioral specs and story-map-driven work ordering are the countermeasures.

**Rule extracted:** The circular validation risk with AI builders isn't solved by file separation — it's solved by authorship separation. You define what the player should experience (behavioral specs), Claude implements it. Both can live in the same repo. Don't add ceremony that doesn't earn its keep.

**Workflow impact:** Added Story Mapping and Behavioral Specs sections to the engineering workflow. Replaced "scenario holdout" framing with human-authored behavioral specs in the Execution Readiness Gate.
