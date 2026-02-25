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

---

### 2026-02-07 (Context Drift): Crosscheck refined behavioral specs with five additions

ChatGPT crosscheck on the behavioral specs / story mapping framing validated the core approach and surfaced five useful additions: (1) invariants and property tests for rules that must always hold, complementing example-based specs; (2) spec freeze during EXECUTION to prevent "boiled frog" drift; (3) red-teaming specs before implementation ("list ambiguity points"); (4) checkpoints within larger stories instead of shrinking story size; (5) sacred contract tests — 3-5 identity-level tests that never break (core loop completes, failure is understandable, loop repeats).

**Rule extracted:** The crosscheck workflow works for methodology questions too, not just game design. Concept-level critique from an external LLM catches gaps that are hard to see from inside the workflow you just built.

**Workflow impact:** Added invariants, spec freeze, red team, checkpoints, and sacred contract tests to the engineering workflow.

---

### 2026-02-07 (Context Drift): Workflow principles scale to teams — coordination changes, not philosophy

When considering whether ClaudeGameDevWorkflows should be "solo" vs "team," two rounds of crosscheck with ChatGPT converged on the same answer: the workflow principles (DESIGN/EXECUTION modes, canon docs, spec-as-contract, behavioral specs, write-back) apply identically to teams. What teams add is coordination norms — spec ownership, sign-off gates, doc edit rights — not a different workflow philosophy. The "solo" framing was an artifact of the origin story, not a fundamental limitation.

Separately, AI agent teams (multiple Claude Code sessions coordinated by a lead) need the same contract structure as human-to-AI delegation: inputs, outputs, invariants, stop points, escalation rules. The deliverable packet pattern extends naturally to AI-to-AI communication.

**Rule extracted:** Don't fork workflows for "solo vs team." Keep one spine of principles and add coordination norms as a section, not a separate track. Agents (human or AI) are collaborators with I/O contracts — the same contract structure works for all delegation patterns.

**Workflow impact:** Repositioned repo as "team-ready, solo-friendly." Added Team Considerations and AI Agent Roles sections to the engineering workflow. Added Integrations pointer for execution tooling.

---

### 2026-02-25 (What Remains Above): Separate acceptance criteria from implementation plans

Early projects put acceptance criteria and implementation plans in the same spec file, or scattered them across chat. What Remains Above evolved a D{N} file pattern: `D{N}-acceptance.md` defines what "done" looks like, `D{N}-plan.md` defines how to get there. Separating them enforces that ACs are agreed *before* a plan is written — preventing plan-first thinking where the implementation drives the requirements. The D{N} numbering aligns with Decisions.md entries for traceability.

**Rule extracted:** Acceptance criteria are the most important thing to agree on. Plans follow from them, not the other way around. Separate files enforce this ordering.

**Workflow impact:** Updated execution-mode.md Deliverable Flow with D{N} file pattern. Updated plan-with-team template to write deliverable files instead of specs/.

---

### 2026-02-25 (What Remains Above): Audio hooks transform long agent workflows

Adding macOS TTS hooks (Stop, SubagentStop, Notification) to Claude Code settings means you can walk away during multi-agent orchestration and get called back when attention is needed. The SubagentStop hook extracts the agent name from the JSON payload for specific announcements. This is a quality-of-life improvement that changes how you interact with long-running agent work — you stop watching the terminal.

**Rule extracted:** Lifecycle hooks for audio feedback should be part of every project's initial setup, not an afterthought.

**Workflow impact:** Added hook templates and settings.json template to the templates directory. Added "Audio hooks" tip to Environment Tips in execution workflow.

---

### 2026-02-25 (What Remains Above): Sacred contract tests belong in CLAUDE.md, not just the workflow doc

Sacred contract tests were defined in execution-mode.md but absent from the CLAUDE.md template's Testing section. Since CLAUDE.md is read every session and the workflow doc is only referenced occasionally, the most important testing concept was invisible in daily use. Moving it into the CLAUDE.md template ensures Claude applies it proactively when writing tests for new subsystems.

**Rule extracted:** If a concept should influence every implementation session, it needs to be in CLAUDE.md — not just in a workflow doc that Claude reads "as needed."

**Workflow impact:** Added Sacred Contract Tests subsection to the CLAUDE.md template's Testing section.
