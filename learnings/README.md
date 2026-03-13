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

---

### 2026-02-28 (Context Drift): 3D rendering iteration is uniquely failure-prone with AI

Extended iteration on a React Three Fiber 3D city map (procedural buildings, neon materials, LOD pooling) produced hours of wasted effort across multiple sessions. The failures were not aesthetic judgment calls — they were objective breakages: scenes going white/grey (broken materials), performance regressions, WebGL buffer overflows, buildings visually shifting on zoom (LOD divergence). The file grew to 2688 lines with no one flagging it.

Root causes: (1) Trial-and-error against the user's eyeballs instead of researching Three.js APIs first. (2) Two divergent rendering paths for the same buildings (instanced pool vs render pool) that inevitably fell out of sync. (3) Magic numbers (0.82 inset, 55% band height) lost across context resets and reintroduced at bad values. (4) No automated screenshot capture, so every wrong guess cost a manual feedback loop. (5) No self-review for objective correctness (buffer invariants, material compilation, output parity).

**Rules extracted:**
- **Research first** — when working with unfamiliar 3D/rendering APIs, look up the correct approach before coding. Wrong guesses compound.
- **File size guardrails** — propose splitting at ~500 lines. Rendering helpers, LOD logic, and React components are separate concerns.
- **Named constants with rationale** — critical parameters need comments explaining why, not just what. This survives context loss.
- **Self-review for objective correctness** — check buffer invariants, material assignments, output parity before presenting changes. These are verifiable, not subjective.
- **One rendering path** — prefer a single function with a fidelity parameter over two implementations that render the "same" thing.
- **Automated screenshot capture** — set up Playwright with WebGL-capable browser for visual iteration. Eliminates manual screenshot loops for objective failures.
- **Structured review handoffs** — when external review is needed, produce a review bundle (changed files + summary + specific questions) instead of requiring the reviewer to dig through the repo.

**Workflow impact:** Added Implementation Discipline section to execution-mode.md. Added Web 3D and Unity rendering sections to CLAUDE.md template. Added WebGL/3D stack profile to ui-testing.md.

---

### 2026-03-01 (Context Drift v2): Simulation prototypes need run reports, not just test suites

Tests prove the engine math is correct. They don't tell you whether a 30-turn season *reads well*, whether LLM-driven strategy decisions make sense, or whether the narrative voice is consistent. After building a zone-based metagame prototype with 130 passing tests and a 5/5 target arc score, the first live API run produced output that scrolled past in the terminal and couldn't be reviewed later. The engine worked perfectly — but there was no artifact to evaluate.

Simulation and narrative games need a **run report**: a structured artifact saved after every prototype run that captures mechanical metrics, per-turn narrative output, strategic decisions, and engine events in a reviewable format. This is the simulation equivalent of an automated screenshot for visual work — without it, evaluation requires re-running and watching in real-time. Mock runs become the baseline; API/LLM runs get evaluated against them.

**Rule extracted:** Tests validate correctness. Run reports validate *quality*. For any game with procedural/simulated output (seasons, campaigns, narrative arcs), the prototype must produce a reviewable artifact per run — not just pass/fail. This belongs in the Verification Loop alongside "prove it works."

**Workflow impact:** Gap identified in execution-mode.md — the Verification Loop covers tests and behavioral specs but not evaluation of procedural output. Recommend adding a "Run Reports" subsection to the Verification Loop: for simulations and narrative games, every prototype run should save a structured report (JSON + human-readable summary) that can be reviewed, compared across seeds, and used as a baseline.

---

### 2026-03-05 (Vela City Map): External "build playbook" reconciliation — response discipline vs process discipline

ChatGPT generated an "LLM Build Playbook" with artifact-first response rules, drift headers, Three Anchors (Structure/Golden Example/Hard Constraints), and per-pass iteration discipline. Initial concern was that ClaudeGameDevWorkflows was missing something fundamental. On comparison, ~70% was already covered (drift control via Now.md/write-back, scope discipline via modes, determinism requirements, validation checklists). The remaining ~30% was genuinely new but complementary — it constrains *how Claude responds during each turn* rather than *what process to follow*.

Key unique contributions absorbed: (1) artifact-first format (lead with code, not explanation), (2) per-artifact drift headers (VERSION/SCOPE/DO NOT CHANGE/CHANGE ONLY), (3) Three Anchors mental checklist, (4) domain-specific style rules for spatial content (grid model, semantic placement, variety caps) and narrative content (message length, source-first ordering). The playbook's strict response template (NEXT ARTIFACT / VALIDATION / ASSUMPTIONS) is useful during pure execution but too rigid for design discussions — the existing DESIGN mode already handles that gap.

**Rule extracted:** Process discipline (when to design vs build) and response discipline (how to structure each turn's output) are separate concerns. Both matter. A project can follow perfect process but still produce bloated responses that bury the deliverable under prose — or produce tight artifacts without any session-level continuity.

**Workflow impact:** Created `workflows/build-discipline.md` as an execution-mode companion. Not merged into execution-mode.md because it's about response format, not engineering process.

---

### 2026-03-12 (Context Drift): Passive context beats active retrieval for agent knowledge

Vercel's AGENTS.md evaluation data showed that embedding domain knowledge directly in instruction files (AGENTS.md, CLAUDE.md) outperforms teaching agents to use retrieval tools (like skills or MCP servers) to look up the same knowledge. The key insight: agents deciding *when* to look something up is itself a failure mode — they don't know what they don't know. Passive context (always loaded) eliminates that decision entirely.

For game dev projects with large doc sets, the practical application is a **compact doc index in CLAUDE.md** — a topic→file→one-line-summary lookup table that's always in context. The agent doesn't need to decide whether to read the naming guide; it sees the index entry and reads it when relevant. This is cheaper than loading full docs into CLAUDE.md but more reliable than hoping the agent searches for them.

**Rule extracted:** When project knowledge is critical (vocabulary, architecture decisions, design constraints), put it in the instruction file or put an index entry pointing to it. Don't rely on the agent to decide to look it up — the retrieval decision is the weak link.

**Workflow impact:** Added "Retrieval-Led Reasoning" section to the CLAUDE.md template with guidance on doc indexes. Added Vercel article references to execution-mode.md.
