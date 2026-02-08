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

## The Canon (5 docs, no more)

Claude reads these automatically via CLAUDE.md. They are the only source of truth.

| Doc | What it holds |
|-----|--------------|
| **GamePillars.md** | Why the game exists. Audience, tone, core loop, pillars. |
| **SettledDesign.md** | Current game design: mechanics, UI, terms, invariants, glossary. The single source of truth for "what is the game right now." |
| **TechnicalDesign.md** | Engineering: data model, architecture, success criteria, deliverables. |
| **Now.md** | Active question, mode (DESIGN/EXECUTION), layer, current state, open questions backlog. Tiny. Always current. |
| **Decisions.md** | Chronological decision log with rationale, deprecated terms, and revisit triggers. |

**No separate docs for:** prototype history (git is the history), open questions (bottom of Now.md), glossary (inside SettledDesign.md), design invariants (inside SettledDesign.md).

> **Adapt this:** Your doc names might differ. A board game might replace TechnicalDesign.md with ComponentSpec.md. A narrative game might add WritingGuide.md. Keep the count to 5-7 max — more than that and nothing gets read.

---

## Layer Declaration

Every design task is tagged as one of these layers. This prevents mixing concerns in a single conversation.

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

> **Adapt this:** Your layers might be different. A board game might split System into Rules/Components/Interaction. A narrative game might split Representation into Writing/Visual/Audio. A multiplayer game might add Networking/Social. The point is: declare a layer, stay in it.

---

## One Active Question at a Time

If the conversation branches, Claude asks: *"Which question are we answering now?"* Everything else goes to the open questions backlog in Now.md.

This prevents the most common failure mode: generating endless ideas without deciding anything.

---

## The Design Conversation Pattern

1. **Declare the layer** — "We're working on [System / Mechanics]"
2. **Declare the maturity** — Is this Established, Speculative, or an Open Question?
3. **Generate 3-5 options**, bucketed, with 1-2 examples each — then narrow and recommend
4. **If changing an Established item**, frame it as a **Change Proposal** with rationale
5. **End with**: a draft Decision Log entry + updated open questions

---

## Guardrails Claude Enforces

1. **One active question at a time.** Everything else goes to the backlog.
2. **Design docs are canon, not vibes.** Changing an invariant requires a Change Proposal with rationale.
3. **Build forward, don't backfill.** If something seems missing, design it new. Don't resurrect old ideas from git history. If an old idea is worth revisiting, quarantine it as "Candidate Re-adoption (NOT ACTIVE)" first.
4. **Out-of-scope gets logged, not lost.** Questions outside the current mode/layer get recorded as open questions or future tasks.
5. **Sessions end with write-back.** Every design session produces:
   - Settled decisions → Decision Log entries
   - Updated open questions → Now.md
   - Updated source of truth → SettledDesign.md (if anything is now Established)

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
- **Mechanics, UI labels, glossary** → SettledDesign.md
- **Design rationale, deprecated terms** → Decisions.md
- **Game identity, pillars, tone** → GamePillars.md
- **Data model, engineering** → TechnicalDesign.md
- **Current focus** → Now.md

---

## Session Wrap

Run this before ending any DESIGN mode session. Takes 2-3 minutes and saves the next session from starting blind.

- [ ] **Decisions logged** — Every decision made this session has an entry in Decisions.md (date, layer, what/why/deprecated/revisit-if)
- [ ] **SettledDesign.md updated** — Anything that moved from Speculative to Established is written back
- [ ] **Now.md current** — Active question reflects where you actually stopped (not where you planned to stop). Open questions backlog includes anything that came up and wasn't resolved
- [ ] **Mode correct** — If you're switching to EXECUTION next, Now.md says so
- [ ] **Commit** — All doc changes committed with a descriptive message

If you skip this, the next session starts with stale context and you'll spend 15 minutes reconstructing what you decided.

---

## If You Do Only Two Things

1. Keep **Now.md** current (active question + mode + open questions)
2. End sessions with **write-back** (decisions to Decisions.md, state to SettledDesign.md)
