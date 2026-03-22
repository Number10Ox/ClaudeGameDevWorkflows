# Skill Authoring Guide

> How to create effective Claude Code skills for this project. Reusable reference for requesting new skills.

---

## What Skills Are

Skills are markdown files with YAML frontmatter that give Claude specialized instructions for specific tasks. They follow the [Agent Skills open standard](https://agentskills.io/specification) adopted by 40+ AI tools.

- **Old format:** `.claude/commands/name.md` (still works, deprecated)
- **New format:** `.claude/skills/name/SKILL.md` (recommended — supports subdirectories)

Skills load automatically. No manifest or registration needed.

---

## Directory Structure

```
.claude/skills/skill-name/
├── SKILL.md              # Required: frontmatter + instructions
├── references/           # Optional: detailed docs, checklists
│   ├── RULES.md
│   └── EXAMPLES.md
├── scripts/              # Optional: executable helpers
│   └── validate.sh
└── assets/               # Optional: templates, schemas
    └── template.md
```

**Scoping:**
- **Project:** `.claude/skills/` (committed to git, shared with team)
- **Personal:** `~/.claude/skills/` (all your projects)
- **Plugin:** bundled with plugins, namespaced `plugin:skill`

Priority: enterprise > personal > project.

---

## SKILL.md Anatomy

```yaml
---
# FRONTMATTER (YAML)
name: skill-name                          # Required. 1-64 chars, lowercase + hyphens
description: What it does and when...     # Required. 1-1024 chars. Drives auto-invocation
argument-hint: [optional-args]            # Optional. Shown in autocomplete
disable-model-invocation: false           # true = only user can invoke via /skill-name
user-invocable: true                      # false = only Claude can invoke (hidden from / menu)
context: fork                             # Optional. Run in isolated subagent
agent: Explore                            # Optional. Subagent type when context: fork
allowed-tools: Read, Grep, Glob           # Optional. Restrict tool access
model: claude-opus-4-6                    # Optional. Override session model
effort: high                              # Optional. low|medium|high|max
---

# Markdown body: instructions Claude follows when skill activates

## Steps
1. Read $ARGUMENTS
2. Do the thing
3. Report results

## Variables
- `$ARGUMENTS` / `$0`, `$1` — user-provided args
- `${CLAUDE_SKILL_DIR}` — path to skill directory
- `${CLAUDE_SESSION_ID}` — current session
- `!`command`` — dynamic context injection (runs before skill loads)
```

---

## Invocation Control Matrix

| Setting | User invokes | Claude invokes | Description in context |
|---------|-------------|---------------|----------------------|
| Default (both false) | Yes | Yes | Yes |
| `disable-model-invocation: true` | Yes | No | No |
| `user-invocable: false` | No | Yes | Yes |

---

## The Description Field

**This is the most important field.** Claude uses pure language model reasoning — no embeddings, no classifiers — to decide when to invoke a skill based on its description.

**Write descriptions that:**
- Sound like how a user would ask for the task
- Name exact trigger scenarios: "Use when writing narrative text, editing agent comms, or reviewing mission scripts"
- Stay under ~20 words for the core, with optional detail after
- Avoid generic keywords ("helps with code")

**Test descriptions** by creating 10 should-trigger and 10 should-not-trigger queries and checking activation rates.

---

## Context Budget

Descriptions always load (50-200 tokens each). Full skill body loads only on activation. Keep SKILL.md under 500 lines. Move reference material to `references/` subdirectory.

Run `/context` to check for warnings about skills exceeding the budget.

---

## Progressive Disclosure

The Agent Skills standard uses three tiers:

1. **Catalog** (~50-100 tokens/skill): name + description, loaded at startup
2. **Instructions** (<5000 tokens recommended): full SKILL.md body, loaded on activation
3. **Resources** (unlimited): scripts/references, loaded only when referenced

Design skills with this in mind. Don't put everything in SKILL.md.

---

## Key Design Patterns

### Reference skill (inline context)
Rules/conventions that Claude should follow while working. NOT `context: fork`.
```yaml
---
name: api-conventions
description: API design patterns for this codebase
---
When writing endpoints: use RESTful naming...
```

### Task skill (forked subagent)
Discrete task with clear output. Uses `context: fork` for isolation.
```yaml
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---
Research $ARGUMENTS...
```

### Script skill (bundled automation)
Offloads logic to scripts in `scripts/` subdirectory.
```yaml
---
name: visualize
allowed-tools: Bash(python *)
---
Run: python ${CLAUDE_SKILL_DIR}/scripts/visualize.py .
```

### Dynamic context injection
Shell commands run before skill loads, output replaces placeholder.
```yaml
---
name: pr-summary
context: fork
---
PR diff: !`gh pr diff`
```

### Multi-agent parallelism
Skill instructions tell Claude to spawn multiple Task agents concurrently.

---

## Common Pitfalls

1. **Vague descriptions** — false-positive triggers waste context tokens
2. **Too much in SKILL.md** — move reference docs to `references/`
3. **`context: fork` on guideline skills** — subagent has nothing to do, returns nothing. Fork is for tasks, not references
4. **Hardcoded paths** — use `${CLAUDE_SKILL_DIR}` for bundled files
5. **SKILL.md must be uppercase** — lowercase `skill.md` won't be discovered
6. **Skill directory names must be kebab-case** — spaces break loading
7. **Too many skills** — descriptions exhaust the 2% context budget. Check with `/context`
8. **Stale cached skills** — edits during a session may need `/clear` to take effect

---

## Effectiveness Principles

From Anthropic's guidance and community experience:

1. **Start from real expertise** — extract skills from completed tasks, corrections, and project artifacts. Grounded skills outperform generic ones.
2. **Gotchas > generic advice** — "The user_id field is uid in the auth service" beats "handle errors properly."
3. **Provide defaults, not menus** — pick one approach, mention alternatives briefly.
4. **Favor procedures over declarations** — teach how to approach a class of problems.
5. **Add validation loops** — instruct the agent to validate before proceeding.
6. **Refine with real execution** — run skills against real tasks, track failures, add corrections to a Gotchas section.

---

## Validation

The Agent Skills spec provides a reference validator:
```bash
# From https://github.com/agentskills/agentskills/tree/main/skills-ref
skills-ref validate .claude/skills/my-skill
```

Checks: YAML syntax, naming conventions, required fields.

---

## Sources

- [Claude Code Skills docs](https://code.claude.com/docs/en/skills)
- [Agent Skills specification](https://agentskills.io/specification)
- [Agent Skills best practices](https://agentskills.io/skill-creation/best-practices)
- [Description optimization](https://agentskills.io/skill-creation/optimizing-descriptions)
- [Evaluating skills](https://agentskills.io/skill-creation/evaluating-skills)
- [Anthropic example skills](https://github.com/anthropics/skills)
- [Inside Claude Code Skills (deep dive)](https://mikhail.io/2025/10/claude-code-skills/)
- [Claude Agent Skills first-principles](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/)
- [Skills + subagents composition](https://towardsdatascience.com/claude-skills-and-subagents-escaping-the-prompt-engineering-hamster-wheel/)
