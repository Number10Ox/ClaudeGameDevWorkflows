# Plans Without Specs

## The Setup

A plan-writing skill (`/plan`) enforces a checklist: acceptance criteria must be concrete and testable, pillar alignment must be stated, a red team agent must surface no FIX items, a hold-out reviewer must read the plan cold and catch what the writer missed. The skill has been in use for months. It works. It catches the failures it is scoped to catch.

It does not ask: "Does a spec exist for what this plan builds?"

## What Happened

A mission generator framework was built through a series of plans over several weeks. Each plan was written under the skill. Each passed red team and hold-out review. Each was implemented cleanly with tests that validated its acceptance criteria. The framework shipped.

Then: a distinctness test produced 0/5 clean on five "variations" of a mission. The judge's rationale cited "same three-beat structure." Accurate — the five variations were rolled from the same template, and the template's ~400-word anomaly block was identical across all five. They were not five missions. They were one mission rendered with different peripheral detail.

Drilling in: the files named `*-structural-template.ts` were fully authored single missions — specific hotel, specific NPCs by name, specific anomaly prose. They were called "templates" because they were used as generator inputs, but they were instances. The terms "template" and "kernel" had been applied to runtime generator arguments rather than to authored artifacts. Nobody had written down what a template was supposed to be, because no spec existed.

The plans had been implementing a mental model of "what a structural template should be" that nobody had written down. Each plan was internally coherent. Each implemented something that made local sense. The cumulative effect was a system with no identity — a pipeline that produced variations of a mission rather than variations across missions, measured by a test asking the wrong question of the wrong artifact.

## Why Compliance Wasn't Enough

Plans are compliant when they list acceptance criteria, align with pillars, pass red team, and implement cleanly. None of that catches "the thing being built has no unified definition." A plan's job is to implement a spec. With no spec, each plan implements the author's current mental model of what the spec would have said — and that mental model drifts session to session. The terminology drifts. The conceptual boundaries drift. The tests measure whatever the last plan's author thought the system was.

The skill did not fail in the "process gate fails silently" sense from `process-gates-agentic-workflows.md`. The skill fired. Its checklist ran. Its reviewers flagged nothing. The failure was that the checklist had no check for "does the thing we're building already have a spec."

## The Fix

Same pattern as Fix Level 1 in the existing process-gates learning: convert a behavioral suggestion into a mechanical prerequisite. Three changes to the plan-writing skill:

1. A pre-writing step verifies a spec path is named and the file exists. If not, the skill blocks and offers three options: reference an existing living doc, author a temporary working spec at `process/spec-<name>.md` first, or extend an existing living doc.
2. "Design Spec" becomes a mandatory plan section: path to the file, one line on what portion of the spec this plan implements.
3. Red team and hold-out reviewers read the named spec. A plan whose spec is missing or whose spec does not cover the build is FIX.

The spec does not have to be long. It has to exist. A terse working spec names the system, its inputs and outputs, and what a correct implementation produces. A few hundred words is enough to catch drift that would otherwise take weeks of compounding plans to become visible.

## The Generalizable Lesson

A skill enforces what it checks. When a skill encodes everything except the thing that matters most, it produces compliance-shaped output for a system that has no underlying identity. The failure is invisible to the skill's own reviewers because the reviewers are scoped to the same checklist.

The question for any skill that enforces a process is not "does it catch failures?" — it's "what failures does its scope even recognize?" If the spec is what keeps a system coherent over time, then "does a spec exist" is the first check, not a downstream verification. Add it to the skill's prerequisite step, not to its final checklist.

## Cross-reference

See [process-gates-agentic-workflows.md](process-gates-agentic-workflows.md) for the broader taxonomy of failure modes this belongs to. The fix here is an instance of Fix Level 1 — converting behavioral suggestion to mechanical path — applied to a prerequisite the skill's original scope did not recognize as relevant. The mechanical pattern is not novel. Noticing the gap in the checklist was what took months.
