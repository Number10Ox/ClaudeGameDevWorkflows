# Narrative Quality Framework

> Game-independent rules for mission/scene narrative in AI-agent games. Extracted from production use across Context Drift, Signal Decay, and Gray Corridors.
>
> For project-specific adaptations (banned terms, faction vocabulary), create a project-level skill that references this framework and adds local rules.

---

## How to Use This

This framework defines pass/fail rules for narrative text in games where an AI agent narrates field experiences to a player. The rules are game-independent — they apply regardless of setting, faction names, or anomaly terminology.

**For Claude Code projects:** Create a `/narration` skill in your project's `.claude/skills/` that references this file and adds your game's specific vocabulary rules, banned terms, and voice definitions.

---

## A. Structural Quality Rules

Six pass/fail rules gate narrative quality. Origin: Gray Corridors tier-2 evaluator.

### A1. anomalyStacking

**Rule:** Max 2 anomaly/threat tells per beat (1 primary + 1 support).

**Counts as tells:** Measured impossibilities, sensory impossibilities, cognitive anomalies, physics violations.

**Does NOT count:** Character behavior, human strangeness, evidence documents, plot context, NPC dialogue content, environmental texture.

### A2. sourceFirst

**Rule:** Discoveries are preceded by the action or perception that reveals them. The agent can't know something without a way of knowing it.

- **Pass:** "I pressed the back of my hand to the door. Warm." (Action, then discovery.)
- **Pass:** "The waiting room is full and nobody is talking." (Perception available on entry.)
- **Fail:** "The door is warm." (No preceding physical action.)
- **Fail:** "The coherence curve shows steady improvement." (How? Did the agent access a screen?)

**Ordering is flexible, not fixed.** The sequence perception → movement → interaction → discovery → reaction is a possible flow, not a mandated one. Sometimes perception comes before position. Sometimes discovery triggers movement. The constraint is that knowledge must be reachable — not that the agent must narrate arrival before noticing what's wrong.

### A3. epistemicIntegrity

**Rule:** The agent reports only what it has (a) observed or perceived, (b) been told by someone present, or (c) read from a document it accessed.

**Line-of-sight constraint:** Cannot report NPC locations or actions unless in the same space or via communication link.

**Violations:** Knowing NPC locations without line-of-sight, knowing facts from unaccessed documents, stating NPC internal states, presenting threat mechanics as known facts.

**Narrator scoping note:** If your game has a character/consciousness narrator, that narrator's established perceptual abilities count as valid channels. A character who can "feel the seams in edited reality" can report that perception — it's not an epistemic violation, it's the character's defined mode of knowing. The ban is on unexplained knowledge, not on the character's established capabilities. See Section E for multi-narrator scoping.

### A4. actionSalience

**Rule:** All decision options must force an immediate physical change with a clear cost. Not "go talk to someone" — "put your body somewhere that changes what happens next."

- **Pass:** Options with explicit physical action + named cost/risk + irreversible consequence.
- **Fail:** "Go talk to [NPC]" without stated cost. "Observe" without stated risk. Delegating action.

### A5. characterLegibility

**Rule:** Every NPC who appears exhibits at least one distinctive human behavior — a habit, tic, deflection, emotional tell, or personal quirk. Name + role alone does not count.

### A6. handlerChoiceLegibility

**Rule:** Every handler/player choice must state what the agent gains and what the agent risks, in terms the player can see change on screen. Must connect to a concrete gameplay consequence — not an abstract verb.

- **Banned framing:** "Map the discrepancy." "Mark as interference." "Study the feeds." "Investigate further." These describe process, not consequence.
- **Test:** Can the player finish "If I pick A instead of B, then ___"? If the blank is vague, the choice has failed.

---

## B. Narration Voice Rules

Eight rules defining the voice target. An LLM given these rules and the game payload should clear the quality bar.

### B1. No stat dumps
Never narrate stats as numbers. Stats surface only as felt experience: "I feel steady," not "Composure 5."

### B2. Felt experience over diagnosis
Not "the anomaly is displacing local physics." Instead: "the water's moving uphill." Trust the reader.

### B3. Agent may rationalize missing info
When information is hidden or corrupted, the agent dismisses or explains it away. It doesn't flag gaps — it fills them with false confidence.

### B4. No genre-savviness
No "this feels like a horror movie." No knowing irony. The agent is experiencing something new and strange, not performing awareness of a genre.

### B5. Corruption reduces certainty, not increases melodrama
A compromised agent doesn't get dramatic. It gets vague, reassuring, slightly wrong. Confidence where there should be doubt.

### B6. Mechanical mentions feel incidental
"I chose to hold back and seal the area" not "I chose Quiet posture and Seal objective." Game terms as shorthand the agent would actually use, not protocol readout.

### B7. People over architecture
The encounter should feel like an interaction, not a checkbox. (Voice-dependent — some agents notice people first, others notice environment first, but encounters always feel human.)

### B8. Short paragraphs, plain language
No purple prose. No elaborate metaphors. Horror/tension comes from what's described, not how it's described. If a sentence works without an adjective, cut the adjective.

---

## C. Failure Modes

Flag if ANY of these patterns appear in narrative text:

### C1. Too much diagnosis
Agent explains what the threat/anomaly is doing instead of describing what it sees. "The anomaly is displacing local geometry" — FAIL. "I think I'm turned around" — PASS.

### C2. Too much purple prose
Elaborate metaphors, poetic horror, atmospheric overwriting. Voice should be plain and sincere.

### C3. Too much stat language
Stats recited as readouts instead of felt experience or brief asides.

### C4. Too much explicit horror/tension
Agent describes things as terrifying, horrifying, or nightmarish. Agent doesn't know it's in a horror story. It's reporting what happened.

### C5. Too much lore confidence
Agent speaks knowledgeably about threat types, faction strategy, or world mechanics. It's a field operative, not a theorist. Describe encounters, not understanding.

### C6. Too much blocking
Scene opens with transit geometry — where the agent is, where they move, what they approach — before consciousness or content. "I stop at the entrance. I scan the room. Six chairs. A reception desk." Stage directions first, experience nowhere. Movement is the vehicle, not the content. (See also A2 — ordering is flexible, but defaulting to blocking-first is a failure pattern.)

### C7. Too much provenance
Every claim carries a sourcing paragraph. The agent says "she is lying" and then immediately dumps three sentences of evidence. In natural dialogue, the agent states the conclusion; the player asks for details if they want them. Provenance emerges through interaction, not exposition.

---

## D. Voice Constraints

### D1. Non-human agents (if applicable)
If agents are non-human entities: no physical sensation references (teeth, skin, warmth, body aches). Wrongness is in the instruments and the environment. Adapt this rule to your game's agent nature.

### D2. Only witnessable facts
No backstory. No "someone did X" unless direct evidence is in view. No omniscient deductions.

**Narrator scoping note:** For a consciousness narrator, "witnessable" includes the character's established perceptual abilities. A character who feels that a place has been disturbed can report that — it's witnessed through their mode of perception. The ban is on omniscient knowledge the character has no channel to receive. See Section E.

### D3. Horror/tension through implication
Contradiction, agency where there shouldn't be, causality running wrong. Never stated explicitly. The reader sees what the agent can't.

### D4. Four-constraint voice model
Each agent is defined by four behavioral constraints:
1. **What they notice first** — people, discrepancies, threats, patterns
2. **Response to danger** — curiosity, empathy, aggression, withdrawal
3. **Expression profile** — measured, spiraling, clipped, flowing
4. **Verbal marker** — a trigger phrase that fires on specific situations, not every line

This model replaces aesthetic archetype labels ("Machine-Spirit Liturgist," "Empathic Healer") which collapse into the same dry tropes across every LLM context. Define agents by behavior under pressure, not aesthetic category.

### D5. Status bands, not numbers
All readouts use categorical bands (e.g., NOMINAL / DEGRADED / CRITICAL). Never raw values visible to the player.

---

## E. Multi-Narrator Scoping

When a game has multiple narration layers — agent consciousness + camera observer, PC narration + GM narration, character thoughts + environmental description — rules must be scoped to each narrator independently. Applying the same rules uniformly creates structural contradictions that produce compliance prose.

### E1. Identify your narrators

Common narrator types in games:
- **Character/consciousness narrator** — reports experience, perception, felt quality. Inside the experience.
- **Camera/observer narrator** — reports observable behavior, physical evidence. Outside the experience.
- **System/intel narrator** — reports data, comparisons, analysis. The information layer.

Each narrator has a fundamentally different relationship to what it can report.

### E2. Tag rules by narrator

Every rule in your quality checklist should specify which narrator(s) it applies to. Common scoping:

| Rule type | Camera/observer | Character/consciousness |
|---|---|---|
| Observable behavior only | Yes | **No** — character reports perception |
| No internal states | Yes (for NPCs) | **No** — character IS internal state |
| Sourced knowledge | Strict — camera needs evidence | Loose — character can state conclusions |
| Action/body verbs | No — observation verbs | Yes — inside the experience |
| Show-don't-tell | Yes | Partially — character can state perception |

Rules that apply to both narrators: no genre-savviness, no decorative language, banned terms, NPC dialogue rules.

### E3. The canonical contradiction

The most common failure: an "observable only" rule applied to a narrator whose purpose is consciousness. "Could a camera see it?" kills a character's strange perception, felt wrongness, or internal experience. The camera test applies to the camera narrator, not to the consciousness. If your game has a character narrator, that narrator's content IS the non-observable.

### E4. Independent information

Each narrator should provide information the other can't. If both narrators say the same thing, one is redundant. The camera shows what the character can't see about themselves. The character reports what the camera can't perceive. When both channels tell different stories about the same moment, the player has a real decision to make.

### E5. Constraint audit

When adding rules to multi-narrator systems, contradictions accumulate faster because each new rule may be valid for one narrator and invalid for another. Run the constraint audit (see [constraint-audit.md](constraint-audit.md)) more frequently — every 3 new rules instead of every 5.

---

## G. AI-ism Failure Modes (Compliance-Invisible)

Sections A-C catch violations: text that breaks a rule. This section catches a different class — text that follows every rule and still reads as LLM-generated. These patterns are what rule-compliance review cannot detect, because they don't violate any rule. They fail by being generic-literary rather than lived-observation.

Triage by pattern. Each comes with a detection test.

### G1. Hollow Comparison

A sentence with the shape of meaningful observation whose comparison doesn't survive a "because" test. "Warmer than a building this size should be." (Building size doesn't determine expected temperature.)

**Detection:** For any comparison ("warmer than X," "older than Y"), complete the sentence with "because ___." If the because-clause is vague, the comparison is hollow.

### G2. Precision Theater

Specific-seeming details (numbers, dates, measurements) that don't constrain interpretation. "A house that was sold thirty years ago." Why thirty? What changes if it's twenty?

**Detection:** Substitution test — would the sentence's meaning change if the specific number/name/year were different? If no, the specificity is decorative.

### G3. Orphaned Causation

"A made/caused/taught B" with no actual mechanism. "Years of working the night shift had taught him to read people." Night shifts don't teach people-reading.

**Detection:** For any causal claim, complete "A causes B because ___." If the mechanism is vague or circular, the causation is orphaned.

### G4. Tautological Observation

A sentence that restates its own premise using synonyms. "There was something deliberate about the way it had been arranged, as though placed with purpose." Deliberate = with purpose.

**Detection:** Strip the second clause. Does the first clause alone lose meaning? If no, the observation is tautological.

### G5. Unanchored Intensifier

A modifier increasing intensity without the concrete detail justifying it. "A deeply unsettling silence." What makes it unsettling? "Deeply" doesn't answer.

**Detection:** "What sensory detail could replace this modifier?" If a concrete observation would strengthen the sentence, the intensifier was a placeholder.

### G6. Sentiment Mismatch

Heightened register applied to content that doesn't earn it. "He carefully set down the perfectly ordinary cup of coffee." Hedge patterns trigger this: *"something about the way...," "not quite what you'd expect...," "almost as if..."*

**Detection:** "What earns this emotional weight?" If the significance is coming from the adjective/adverb rather than the noun/verb, sentiment is mismatched.

### G7. Definition-as-Metaphor

A construction that explains emotional or physical state through the framing *"the way [one] does [X]"* or *"like [someone] who [Y]"*. The definition IS the description — the prose points to a conceptual reference rather than naming a physical observation.

**Examples:**
- FAIL: *"holding it the way you hold something you want to get right"* — explains emotion through a conceptual category.
- FAIL: *"She spoke with the kind of care that comes from knowing what's at stake."*
- PASS: *"She is holding the frame with a surgical stillness."* — physical observation.
- PASS: *"When she says 'home' the grip on the frame tightens. She says 'home' twice."* — specific physical observation + specific repetition.

**Detection:** Does the sentence answer "how does it feel?" by pointing to a conceptual category (*"the way you do X"*, *"like someone who does Y"*)? If yes, replace with a specific physical or behavioral observation.

### G8. Inference-Disguised-as-Perception

A sentence framed as first-person observation that actually delivers an inference — the evidence is hidden; only the conclusion appears. Related to C1 (too much diagnosis) but specifically in observation-shaped prose.

**Examples:**
- FAIL: *"It has been here before me."* (Inference about prior presence; evidence unstated.)
- FAIL: *"The room remembered its occupant."*
- PASS: *"The chair is warm. No one is here."* (Two perceptions; reader infers.)
- PASS: *"The seat is warm and nobody is here."*

**Detection:** For any observation-framed claim, ask "what specific sensory evidence does the agent register that produces this?" If the evidence isn't in the sentence, the claim is inference-disguised. Replace with the evidence and let the inference follow.

### G9. Rule-Reflex Phrasing (meta-prose specific)

Applies to prose that instructs an LLM about prose — narrator-prompt files, skill documentation, checklist entries. The pattern is the meta-prose version of the "Add a Rule" reflex: the writer identifies a problem, names it by its inverse, and the negation becomes the teaching.

**Examples:**
- FAIL: *"The action is the vehicle, not the decoration."* (In a prompt explaining micro-structure — "vehicle" and "decoration" are abstract categories the LLM will over-apply.)
- FAIL: *"Observation should serve the meaning, not stand alone as atmosphere."*
- PASS: *"Messages proceed from perception toward meaning. The observation lands before the interpretation."* (Names the positive order.)
- PASS: *"Lead with what the agent sees. Let the interpretation follow."*

**Detection (meta-prose only):** Does the instruction teach via "X, not Y" where Y is an abstract quality category? If so, rewrite as a direction or a specific shape rather than a category-negation.

**Scope:** Narrator-prompt artifacts, skill docs, checklist entries, design-doc meta-prose. Does NOT apply to narrative content — narrative can legitimately use "not X but Y" for rhetorical contrast.

### G10. Over-Categorization in Prose

Prose that describes a system by enumerating its categories more than is necessary — naming three modes where two would do, labeling phases where describing a direction would be clearer. Categories create the appearance of structure while teaching the LLM to toggle between buckets rather than vary by content.

**Detection:** Count the categories named. Does every category name a distinct observable thing the LLM needs to pick between, or are some decorative labels? If collapsing reduces count without losing information, the original was over-categorized.

**Caveat:** Not every list is over-categorization. Structural-spine elements (beat order, camera modes, recognition-tag vocabulary) are load-bearing — each names a distinct authoring decision. G10 triggers when the categorization IS the teaching rather than a map of decisions.

### Why these need a separate review pass

The rule-compliance review checks "did the text violate a rule?" AI-ism review checks "does the text read as machine-authored despite following the rules?" These are orthogonal checks. A sentence can pass every rule in Sections A-C and still fail G1-G10.

The canonical surfacing case: a narrator-prompt draft used the phrase *"holding it the way you hold something you want to get right"* as a reference example. The phrase passed decorative-atmosphere, passed named-emotion-proxy, passed diagnostic-narration — passed every rule. It still read as definition-as-metaphor (G7) and was caught only by a separate review pass scoped to AI-ism patterns. The review pass is what closed the gap.

---

## F. Campaign/Seasonal Writing Standards

For games with recurring narrative cycles (daily feeds, seasonal arcs, bulletins).

### F1. Tuesday Test
"A system/process does X, which shouldn't be possible — here's the logged symptom." Every anomaly description must pass this concreteness test.

### F2. Anomaly/threat as protagonist
The thing that's wrong is the hook. Not the response to it.

### F3. Concrete first, abstract second
Specific observable detail before any interpretation.

### F4. No invented jargon
Use the project's documented vocabulary. Don't create new terms that aren't in the naming guide.

---

## Quick-Scan Checklist

Before submitting any narrative text, scan for these common violations:

- [ ] Any raw numbers visible to the player?
- [ ] Any diagnosis instead of observation?
- [ ] Any banned/deprecated terms from the project vocabulary?
- [ ] Any physical sensation references that violate agent nature?
- [ ] Any genre-savvy language ("horrifying," "nightmarish")?
- [ ] Any stat readouts ("Composure 5")?
- [ ] Any vague handler/player choices ("Investigate further")?
- [ ] Any internal tags/mechanics exposed to the player?
- [ ] Any NPCs who are just name + role without behavioral detail?
- [ ] Any discovery without a preceding physical action?
- [ ] Any knowledge the agent couldn't have from direct observation?
- [ ] More than 2 anomaly/threat tells in a single beat?

---

## The Mandatory Review Gate

Reading rules before writing is necessary but **not sufficient**. The writer's context skips violations that a fresh reader catches. In production use, narrative text shipped with raw numbers, diagnosis-over-observation, and missing handler choice costs — all with the rules loaded in the same session.

**The fix: a two-pass enforcement protocol with parallel agents.**

### Character specs are writing prompts. Checklists are verification.

This distinction sounds small. It changes everything about the output.

- **Writing prompt:** character spec (logline, personality, secret, voice model) + situation + beat. "You are this character. You're walking into this place. Something is wrong. Talk to your handler."
- **Verification:** checklists run AFTER writing to catch structural violations. "Did the agent diagnose instead of describe? Did an NPC never speak? Are there more than 2 anomaly tells?"

Writing FROM checklists produces compliance prose — every line exists to satisfy a checkbox. Writing AS the character and then checking specs produces fiction. The failure mode: stacking specs until the writing prompt becomes a compliance audit.

### Writing Mode
1. Load **character/voice spec** as the writing prompt — who the character is, not what rules to follow
2. Write the text as the character in the situation
3. **Launch the review agents** (plural — see below) with the checklists (mandatory, not optional)

### Review Mode — parallel two-agent pattern

Compliance and quality check different things. A line can pass every rule and still read as LLM-generic (see Section G). A separate review pass, running in parallel, closes that gap.

Launch TWO `general-purpose` Task agents in parallel (single message with both tool uses):

**Agent 1 — Rule-Compliance Review.** The agent:
1. Re-reads all source rule docs from disk (fresh context, not inherited from writer)
2. Checks every piece of text against every rule in Sections A-F
3. Reports per rule per text block: **PASS** / **FAIL** / **WARN**
4. For FAILs: quotes the violating text, names the rule, explains why, suggests a fix

**Agent 2 — AI-ism Review.** The agent:
1. Re-reads Section G (AI-ism failure modes) from disk
2. Determines scope — narrative content scans for G1-G8; narrator-prompt or meta-prose artifacts scan for ALL of G1-G10 (RR1/OC1 are meta-prose specific)
3. Applies the detection test for each pattern against every sentence or construction
4. Reports findings per pattern: verbatim quote with location, one-sentence reason, 1-2 specific fix candidates (not generic "rewrite this" — proposed replacement prose)

### Exit criteria
- Zero FAIL results from Rule-Compliance agent (including clarity)
- Zero findings from AI-ism agent
- WARN results reviewed and accepted or fixed

An AI-ism finding is never dismissed on rule-compliance grounds. The whole point of the parallel pass is that compliance and quality are orthogonal checks.

This is the quality gate skill pattern applied to narrative text, extended with a second agent. See `skill-authoring.md` for the general pattern.

---

## Adapting for Your Project

To create a project-specific narration skill from this framework:

1. **Identify your narrators** — how many narration layers does your game have? Tag each rule by narrator (Section E)
2. **Separate writing prompts from verification** — character/voice specs are writing prompts; checklists are verification tools. Keep them in separate files
3. **Define your voice model** — create four-constraint definitions for each agent/narrator
4. **Add vocabulary rules** — your game's canonical terms and banned synonyms
5. **Create a `/narration` skill** in `.claude/skills/narration/` that references this framework and adds your local rules
6. **Wire the review gates** — the skill's SKILL.md should mandate launching TWO review agents in parallel after writing: a rule-compliance agent (checks Sections A-F) and an AI-ism agent (checks Section G). Both agents read from disk for a fresh context; both must pass before presenting text.
7. **Schedule constraint audits** — see [constraint-audit.md](constraint-audit.md) to prevent rule accumulation from producing compliance prose

See `workflows/skill-authoring.md` for how to build the skill (especially the quality gate pattern).
