# Game Design Workflow (DESIGN Mode)

A practical workflow for doing game design with Claude Code without losing decisions, drifting between sessions, or mixing layers.

---

## Two Modes

Every session operates in one of two modes. Check `Now.md` for which one is active.

### DESIGN mode (this document)
Use when exploring, ideating, or making decisions that aren't yet settled.

### EXECUTION mode
Use when implementing a settled decision. See [execution-mode.md](execution-mode.md).

**The rule:** don't mix them. If a design question comes up during execution, log it in Now.md's open questions — don't solve it mid-implementation. If you're tempted to implement during a design session, stop and switch modes explicitly.

---

## The Canon

Claude reads these automatically via CLAUDE.md. They are the only source of truth.

| Doc | What it holds |
|-----|--------------|
| **GamePillars.md** | Why the game exists. Audience, tone, core loop, pillars. |
| **Roadmap.md** | Current + next milestone. What's playable at each, what systems are required, what's deferred. |
| **Now.md** | Active question, mode (DESIGN/EXECUTION), current state, open questions backlog. Tiny. Always current. |
| **Decisions.md** | Chronological decision log with rationale, deprecated terms, and revisit triggers. |
| **Per-system living docs** | One per major system (e.g., `MissionGameplay.md`). Current reality: how the system works, its interfaces, scope, open questions. See [living-doc-template.md](../templates/living-doc-template.md). |

Living docs replace a monolithic "SettledDesign.md" approach. Instead of one doc for the whole game, each system owns its own living doc, updated after implementation. Create a living doc when you first need to change a system — don't pre-create empty ones.

**New systems:** When DESIGN mode produces a settled design for a system that doesn't exist yet, the output is a design spec. That spec becomes the system's living doc after implementation (see [execution-mode.md](execution-mode.md) § New System Flow).

> **Adapt this:** Your doc names might differ. A board game might add ComponentSpec.md. A narrative game might add WritingGuide.md. The per-system living docs scale naturally — you create them as systems emerge, not upfront.

---

## The Design Hierarchy

Every design element belongs to exactly one level. When a new idea, question, or decision surfaces, **classify it before discussing it.**

| Level | What it is | Example |
|-------|-----------|---------|
| **Thesis** | Genre bets. The "why." 1-3 per project, set at start, testable. | "Players enjoy managing unreliable agents" |
| **Pillar** | Experience goals. The feelings you want. Derived from theses. | "Every decision feels like a real tradeoff" |
| **Hypothesis** | Testable mechanical experiments. Format: "If [mechanic], then [pillar] because [reason]." | "If interrupts cost context, players will feel resource tension" |
| **Design Rule** | Authored constraints on how systems behave. Enforced, not tested. | "Agent never outputs numbers" |
| **Scope Boundary** | What's in/out for this version. | "No multiplayer in v1" |

### Classifying incoming ideas

| If it feels like... | It's probably a... | Action |
|---|---|---|
| "We should make a game about X" | **Thesis** | Rare. Log it. Discuss scope change. |
| "The player should feel X" | **Pillar** | Check if it traces to a thesis. |
| "What if the game had X mechanic?" | **Hypothesis** | Frame as "If [mechanic], then [pillar] because [reason]." |
| "X should work this way" | **Design Rule** | Is this a constraint we're choosing to enforce? |
| "We're not doing X for now" | **Scope Boundary** | Add to scope boundaries. |
| "I don't know how X should work" | **Open Question** | Log in Now.md. |
| "X contradicts Y" | **Tension** | Identify which levels conflict. Resolve at higher level first. |

> **Adapt this:** The hierarchy levels are game-independent. Your specific theses, pillars, and rules are project-specific. Some projects may add or rename levels — the principle is: classify maturity before discussing.

---

## Layer Declaration (optional)

For larger projects, tag each design task with a domain layer to prevent mixing concerns in a single conversation.

| Layer | Covers |
|-------|--------|
| **Pillars / Product** | Identity, audience, tone, what kind of game this is |
| **System / Mechanics** | Rules, core loop, economy, failure states, balancing |
| **Representation / Narrative** | Fiction wrapper, voice, meaning, theme, lore |
| **UI / UX** | Flows, screens, hierarchy, readability, controls |
| **Content** | Specific encounters, items, characters, levels, events |
| **Progression / Economy** | Upgrades, unlocks, pricing, resource sinks/sources |
| **Production / Scope** | What's buildable, timeline, tooling, team capacity |

If the conversation drifts to another layer, Claude should flag it: *"That's a [System] question — we're in [UI] right now. Log it or switch?"*

> **Adapt this:** Your layers might be different. A board game might split System into Rules/Components/Interaction. A narrative game might split Representation into Writing/Visual/Audio. The point is: declare a layer, stay in it.

---

## One Active Question at a Time

If the conversation branches, Claude asks: *"Which question are we answering now?"* Everything else goes to the open questions backlog in Now.md.

This prevents the most common failure mode: generating endless ideas without deciding anything.

---

## The Design Conversation Pattern

### Focused Exploration (recommended default)

A structured response format that prevents multi-idea dumps and keeps conversations productive.

**Required response order (every turn):**

1. **Reflection (mandatory, first)** — Restate what you heard in 2-5 lines
2. **One Idea Only (mandatory)** — Present exactly ONE concrete idea or change per reply, tagged with hierarchy level (Thesis / Pillar / Hypothesis / Design Rule / Scope Boundary)
3. **Impact Summary (mandatory, brief)** — What changes, what stays unchanged, why it helps
4. **Parking Lot (optional, stubs only)** — Up to 3 additional ideas, one sentence each — no detail unless the user picks one
5. **Same-Page Check (mandatory, last)** — 2-3 specific alignment questions

**Hard constraints:** No multi-idea dumps. No long screens. Classify every new idea before discussing it.

**Stop rule:** If the user does not confirm alignment, repeat or clarify — do not introduce a new idea.

> **Adapt this:** Some teams prefer a looser conversation style. The Focused Exploration protocol is most valuable when design conversations tend to sprawl or generate ideas faster than they resolve them.

### Alternative: Generate-and-Narrow

A lighter pattern when Focused Exploration feels too rigid:

1. **Declare the layer** — "We're working on [System / Mechanics]"
2. **Declare the maturity** — Is this Established, Speculative, or an Open Question?
3. **Generate 3-5 options**, bucketed, with 1-2 examples each — then narrow and recommend
4. **If changing an Established item**, frame it as a **Change Proposal** with rationale
5. **End with**: a draft Decision Log entry + updated open questions

---

## Research-First Design

When a design question needs external reference — **research before proposing.** Launch parallel agents per distinct research angle. Synthesize results before proposing. This prevents the AI from defaulting to generic game dev patterns from training data when project-specific answers may already exist in predecessor projects, design docs, or external references.

---

## Guardrails Claude Enforces

1. **Classify before discussing.** Every new idea gets tagged with its hierarchy level before analysis begins.
2. **One active question at a time.** Everything else goes to the backlog.
3. **Link hypotheses to pillars.** A hypothesis without a pillar connection is unmoored — it might be interesting but it doesn't serve the game.
4. **Living docs are canon, not vibes.** Changing an invariant requires a Change Proposal with rationale.
5. **Build forward, don't backfill.** If something seems missing, design it new. Don't resurrect old ideas from git history. If an old idea is worth revisiting, quarantine it as "Candidate Re-adoption (NOT ACTIVE)" first.
6. **Out-of-scope gets logged, not lost.** Questions outside the current mode/layer get recorded as open questions or future tasks.
7. **Sessions end with write-back.** Every design session produces:
   - Settled decisions → Decision Log entries
   - Updated open questions → Now.md
   - Updated living docs → if any design calls were made this session

---

## Perspective Pass (optional)

When a design question is close to settled, optionally check it against stakeholder lenses:

| Perspective | What they care about |
|-------------|---------------------|
| **Player First** | Is this fun? Is it clear? How fast do I get to the good part? |
| **Content Creator / Streamer** | Is this watchable? Can I explain it in 30 seconds? |
| **Fellow Dev** | Is this technically interesting? What's novel about the approach? |
| **The Game Itself** | What would agents/characters "care about" in-fiction? |

Record conflicts and what you're optimizing for. Most useful for naming, onboarding, and player-facing copy. Skip it for internal mechanics.

> **Adapt this:** Replace these with perspectives relevant to your game's audience. A kids' game might have Parent/Teacher/Child. A competitive game might have Casual/Ranked/Tournament. A narrative game might have Reader/Completionist/Speedrunner.

---

## Doc Hygiene (run after any terminology or structure change)

After changing terminology, phase names, UI labels, or workflow structure, audit all docs for:

1. **Single responsibility** — each doc has one job; if content belongs elsewhere, move it
2. **DRY** — if the same fact is in two places, one references the other (the canonical source)
3. **Stale terminology** — search all docs for deprecated terms (check Decisions.md)
4. **CLAUDE.md consistency** — session start references must match what docs actually exist

Canonical sources (when stated in two places, the canonical source wins):
- **System mechanics, behavior, interfaces** → per-system living docs
- **Design rationale, deprecated terms** → Decisions.md
- **Game identity, pillars, tone** → GamePillars.md
- **Milestones, deferred work** → Roadmap.md
- **Current focus** → Now.md

---

## Session Wrap

Run this before ending any DESIGN mode session. Takes 2-3 minutes and saves the next session from starting blind.

- [ ] **Decisions logged** — Every decision made this session has an entry in Decisions.md (date, layer, what/why/deprecated/revisit-if)
- [ ] **Living doc(s) updated** — If any design calls were made, the relevant system doc reflects them
- [ ] **Now.md current** — Active question reflects where you actually stopped (not where you planned to stop). Open questions backlog includes anything that came up and wasn't resolved
- [ ] **Mode correct** — If you're switching to EXECUTION next, Now.md says so
- [ ] **Commit** — All doc changes committed with a descriptive message

If you skip this, the next session starts with stale context and you'll spend 15 minutes reconstructing what you decided.

---

## If You Do Only Two Things

1. **Classify** every new idea into the hierarchy before discussing it
2. **Write back** at session end (decisions to Decisions.md, state to living docs, Now.md current)
