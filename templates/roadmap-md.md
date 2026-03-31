# Roadmap.md Template

> Copy this to your project as `Docs/Roadmap.md`.
> Forward-looking strategic doc: what you're building toward, not what you've done.
> Always exactly two entries: current milestone + next milestone. When current completes, next becomes current and you define the new next.

---

```markdown
# Roadmap

## Current: {Milestone Name} (M{N})

**Goal:** {1-2 sentences — what the player can do that they can't do now}

**Playable state at completion:**
- {Concrete, demonstrable capability}
- {Concrete, demonstrable capability}

**Required systems:**
- {System name} — {brief description of what it needs to do}
- {System name} — {brief description}

**Deferred from M{N}:**
- {Feature/capability} — deferred to M{N+1} because {reason}

**Remaining deliverables:**
- [ ] {Deliverable description}
- [ ] {Deliverable description}

---

## Next: {Milestone Name} (M{N+1})

**Goal:** {1-2 sentences — what this milestone adds}

**Playable state at completion:**
- {Concrete, demonstrable capability}

**Required systems:**
- {System name} — {brief description}

**Likely deferred:**
- {Things you expect to push to M{N+2}}
```

---

## How to Use

- **Update frequency:** When a deliverable completes, check off or remove it from "Remaining." When a milestone completes, archive it and promote the next milestone to current.
- **Relationship to tracking docs:** Your deliverable tracking (TDD.md, issue tracker, etc.) tracks what's done. Roadmap.md tracks what you're building toward. They complement, not duplicate.
- **Milestone scope:** A milestone should represent a meaningfully different playable state. If you can't describe what the player can do differently at completion, the milestone is too small (it's a deliverable) or too vague (it needs scoping).

> **Adapt this:** Two milestones is the recommended limit for context window efficiency — more than that and you're speculating. If your project has a fixed release schedule, you might include three. The principle is: enough to know where you're headed, not so much that you're maintaining fiction.
