# Contributing

This repo captures game dev workflows for Claude Code. Contributions come in two forms: **learnings** (observations from projects) and **workflow changes** (modifications to the workflows or templates themselves).

## Adding a Learning

When a project teaches you something about working with Claude Code on game dev, add an entry to `learnings/README.md`.

**Format:**

```markdown
### YYYY-MM-DD ([Project Name]): [One-line summary]

[2-5 sentences: what happened, what you learned, how it changes the workflow.]

**Rule extracted:** [The generalizable takeaway.]

**Workflow impact:** [Which workflow or template should change, or "none — just awareness"]
```

Learnings don't need to propose a specific workflow change. Sometimes the value is just awareness.

## Proposing a Workflow Change

If a learning (or repeated experience) suggests a workflow or template should change:

1. **Start with the learning.** Document it in `learnings/` first. Changes without context tend to drift.
2. **Edit the workflow/template.** Make the change directly. Keep adaptation notes (`> **Adapt this:**`) current.
3. **Check cross-references.** If you rename a section or move content, search for references in other files.
4. **One change per commit.** Don't bundle unrelated workflow changes.

## Adding a Recipe

Recipes go in `recipes/`. They answer "I'm in X situation, what do I do?"

Good recipes are:
- **Situational** — triggered by a specific problem, not general advice
- **Short** — under 30 lines of content
- **Actionable** — numbered steps, not paragraphs of philosophy
- **Linked** — reference the relevant workflow doc for full context

## What Doesn't Belong Here

- Project-specific content (your game's mechanics, data model, lore)
- Generic software engineering practices (unless game-dev contextualized)
- Tool comparisons or reviews
- Tutorials on how to install or configure Claude Code
