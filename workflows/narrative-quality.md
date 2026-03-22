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

**Rule:** Discoveries are preceded by the physical action that reveals them. Action then discovery, in that order.

- **Pass:** "I pressed the back of my hand to the door. Warm."
- **Fail:** "The door is warm." (No preceding physical action.)

### A3. epistemicIntegrity

**Rule:** The agent reports only what it has (a) physically observed, (b) been told by someone present, or (c) read from a document it accessed.

**Line-of-sight constraint:** Cannot report NPC locations or actions unless in the same space or via communication link.

**Violations:** Knowing NPC locations without line-of-sight, knowing facts from unaccessed documents, stating NPC internal states, presenting threat mechanics as known facts.

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

---

## D. Voice Constraints

### D1. Non-human agents (if applicable)
If agents are non-human entities: no physical sensation references (teeth, skin, warmth, body aches). Wrongness is in the instruments and the environment. Adapt this rule to your game's agent nature.

### D2. Only witnessable facts
No backstory. No "someone did X" unless direct evidence is in view. No omniscient deductions.

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

## E. Campaign/Seasonal Writing Standards

For games with recurring narrative cycles (daily feeds, seasonal arcs, bulletins).

### E1. Tuesday Test
"A system/process does X, which shouldn't be possible — here's the logged symptom." Every anomaly description must pass this concreteness test.

### E2. Anomaly/threat as protagonist
The thing that's wrong is the hook. Not the response to it.

### E3. Concrete first, abstract second
Specific observable detail before any interpretation.

### E4. No invented jargon
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

## Adapting for Your Project

To create a project-specific narration skill from this framework:

1. **Copy the quick-scan checklist** and add your game's banned terms
2. **Define your voice model** — create four-constraint definitions for each agent/narrator
3. **Add vocabulary rules** — your game's canonical terms and banned synonyms
4. **Add number display rules** — what numeric info (if any) the player sees, and in what format
5. **Create a `/narration` skill** in `.claude/skills/narration/` that references this framework and adds your local rules

See `workflows/skill-authoring.md` for how to build the skill.
