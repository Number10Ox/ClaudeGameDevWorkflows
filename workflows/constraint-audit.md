# Constraint Audit

> Prevents the monotonic accumulation of creative rules from producing compliance prose. Applicable to any game with narrative output, voice constraints, or quality checklists managed by AI.

---

## The Problem

The cycle: you write something, it's not good enough, you correctly identify what's missing, you write a rule, the rule works, you repeat. Each rule solves the problem it was written for. None are wrong individually. But rules only accumulate — nobody goes back and asks "now that we have rule 17, do rules 3 and 8 still need to exist in their current form?"

By the time the constraint count hits twenty or thirty, the writing is optimizing for compliance rather than quality. The output is technically correct, rule-satisfying, and creatively dead. The rules feel like progress — each one makes the next draft better on the dimension it targets. But each one also makes the next draft worse on the dimension of "does this sound like a person wrote it."

This happens in every creative-technical project that runs long enough. It is not a failure of discipline — it is a structural trap built into the feedback loop between identifying gaps and writing rules to fill them.

---

## When to Run

Run the audit when ANY of:
- **Five new rules** have been added to any quality system since the last audit
- **Two weeks** have passed during active content development
- **A quality review** reveals writing that is technically correct but feels dead, formulaic, or checklist-shaped

The audit takes thirty minutes. The mess it prevents takes weeks to untangle.

---

## The Three Questions

### 1. Count the constraints

Literally count every rule, checklist item, quick-scan checkbox, PASS/FAIL example, and spec requirement that applies to a single piece of writing. Count separately for each artifact type your game produces (agent narration, environmental description, player choices, NPC dialogue, etc.).

**Danger zone: more than 15 simultaneous constraints on any single artifact type.**

At that threshold, the writer (human or AI) is no longer writing — they're solving a constraint satisfaction problem. The output reads like a solution to that problem.

### 2. Test for contradiction

Take every pair of rules that apply to the same artifact and ask: **can a single sentence satisfy both?**

Common contradiction patterns:
- "Observable behavior only" + "felt experience as content" — camera rules applied to a consciousness
- "Every claim needs provenance" + "natural dialogue flow" — sourcing mandates vs conversational voice
- "Fixed narrative ordering" + "consciousness before position" — structural mandates vs organic flow
- "Physical behavior in every beat" + "narrator speaks only when needed" — schedule mandates vs earned moments

Any contradicting pair must be resolved: scope one rule to a specific context, deprecate one, or rewrite both to be compatible.

### 3. Test for life

Take the five best lines from the most recent draft — the lines that actually work, that a player would quote to a friend. Run each line against every rule.

**If any of the best lines violate a rule, that rule is wrong or too broad.**

The rules serve the writing. The writing does not serve the rules. A rule violated by a line that works is a candidate for rescoping — not evidence that the line should be rewritten.

---

## The Deeper Discipline

The audit catches the problem after it starts growing. The deeper fix prevents it from starting: **rules should be deprecated as aggressively as they're created.**

Every time you add a rule, ask: does this new rule make any existing rule redundant, too narrow, or contradictory? If yes, modify or remove the old rule in the same commit. The constraint count should stay roughly stable over time, not grow monotonically.

The previous project and this one both grew the ruleset without ever shrinking it. That's the pattern to break. Not "periodically review the rules" — that's cleanup. The real discipline is: every rule addition is also a rule review. You never add to the stack without checking what the addition makes obsolete.

---

## How to Run

Give Claude (in conversation, not during execution) the following prompt:

> Here are all the rules that apply to [artifact type]. Count them. Find contradictions. Then take these five lines that work well and check which rules they violate. Any rule violated by a line that works is a candidate for rescoping.

Provide: the relevant checklist files, voice/character specs, and the five best lines from recent writing.

---

## Audit Log Template

Keep a running log in your project's `process/` directory. Each entry:

```markdown
### YYYY-MM-DD — [trigger]

**Constraint count before:** [per artifact type]
**Contradictions found:** [list with resolution]
**Rules rescoped or removed:** [list]
**Constraint count after:** [per artifact type]
**Best-line test:** [which lines, which rules they violated, how rules were rescoped]
```

The log creates accountability. You can look back and see the constraint count over time and understand why rules were changed.

---

## Relationship to Other Workflows

- **narrative-quality.md** — the framework most likely to accumulate contradictions, since it grows through playtest feedback
- **skill-authoring.md** — skills that load rules should track how many rules they load; a skill loading 40 constraints is in the danger zone
- **build-discipline.md** — the Three Anchors pattern (max 10 constraints per deliverable) is a related discipline at the artifact level
