# Cross-checking with External LLMs

Using other LLMs (ChatGPT, Gemini, etc.) for brainstorming is valuable — they find blind spots and generate concepts from a different angle. But they don't have your codebase context, so their output needs filtering.

---

## Bring Back (high value)

| Type | Why it works | Example |
|------|-------------|---------|
| **Concept-level ideas** | Fresh angles on design problems | "What if the unreliable narrator mechanic extends to the data model?" |
| **Naming/framing alternatives** | Competing metaphors to stress-test yours | "Your 'doctrine' concept could also be framed as 'world law'" |
| **Style/tone specs** | Constraints and examples for writing | Tone bible with rules, good/bad examples, character limits |
| **Identified tensions** | "Your X doesn't fit with Y" observations | "Your procedural skin doesn't support mutable reality" |
| **Questions you hadn't asked** | Gaps they spot from outside | "Who decides the failure mode — the system or the character?" |

---

## Filter Aggressively (low value / harmful)

| Type | Why it fails | What to do instead |
|------|-------------|-------------------|
| **Schemas / data models** | They don't know your existing types | Evolve your canonical model based on settled decisions |
| **Code / implementation files** | Parallel type systems, reinvented wheels | Write code in the codebase with full context |
| **Renamed terminology** | They don't know what's already settled | Check SettledDesign.md before accepting |
| **"Full pipeline" architectures** | Scope creep disguised as helpfulness | Log the useful sub-idea, discard the wrapper |
| **Hardcoded answers to open questions** | Treats unresolved design as settled | Keep it in Now.md backlog until you decide |

---

## When to Cross-check (proactive triggers)

These are moments in the design process where an outside perspective has the highest payoff:

| Trigger | Why cross-check helps | What to ask |
|---------|----------------------|-------------|
| **Naming a core concept** | You're too close to it; outsiders catch confusion faster | "Does this term communicate X to someone who hasn't read our docs?" |
| **Metaphor/framing feels wrong** | Tension between mechanic and fiction wrapper | "Here's what the system does. Does this skin/metaphor fit?" |
| **Stuck on a design question for >1 session** | Fresh framing can unstick you | Share the question + constraints, ask for 3 different approaches |
| **New player-facing text spec** | Tone/voice rules benefit from adversarial examples | "Here's our tone spec. Write 5 examples. Which ones break the rules?" |
| **About to settle a multi-option decision** | Confirmation bias risk | "Here are 3 options we're choosing between. What are we missing?" |
| **After a major design shift** | Blind spots in the new direction | "We just changed X to Y. What breaks?" |

**Don't cross-check:** implementation details, data model shapes, code structure, anything that requires codebase context to evaluate correctly.

---

## The Crosscheck Workflow

1. Have the external conversation about a **concept or design question**
2. Bring the **transcript or key ideas** to Claude Code (which has full codebase context)
3. Claude Code assesses: what's new, what's redundant, what contradicts settled design
4. **Extract**: new ideas → open questions backlog or settled design
5. **Discard**: schemas, code, terminology changes, premature architecture

---

## Rule of Thumb

If the external LLM's output requires knowing your codebase to be correct, discard it. If it's useful even without knowing your codebase, keep it.
