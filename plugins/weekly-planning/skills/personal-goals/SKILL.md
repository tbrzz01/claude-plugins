---
name: personal-goals
description: |
  Manage OKR-style personal professional goals and integrate them into weekly plans and reflections.

  Use this skill when:
  - The user invokes /personal-goals or /goals
  - The user says "update my goals", "quarterly goals", "set my goals", "review my goals", "what are my goals"
  - AFTER creating a new weekly plan (new-week) — add goal alignment and flag uncovered goals
  - DURING a weekly review or Friday wrap-up — generate progress summary, reflection prompts, and weekly nudges
  - The user asks "how am I tracking against my goals", "what goal should I focus on", or "does my week ladder up to my goals"

  Always offer to run this skill after new-week completes. Always include it in Friday/weekly review flows.
---

## Setup: Resolve Config Paths

Before any file operation, resolve `{placeholder}` references in this file:

1. Read `plugins/weekly-planning/config.local.json` (fall back to `config.example.json` if missing).
2. Substitute each `{placeholder}` with the matching key from the config. Top-level keys (e.g. `docs_root`, `templates_root`, `personal_root`) and `subpaths` keys (e.g. `weekly_plans`, `meeting_notes`, `hub`, `teammembers`, `myteam_index`, `notes_template`, `goals_file`) are valid.
3. Subpath values may themselves reference `{docs_root}` etc. — expand recursively.
4. Tilde (`~`) at the start of a path expands to `$HOME`.

If `config.local.json` is missing, tell the user to copy `config.example.json` to `config.local.json` and fill in their paths before continuing.


# Personal Goals Skill

This skill manages your OKR-style personal professional goals and weaves them into your weekly workflow in three modes:

1. **`/personal-goals`** — create or update your quarterly goals
2. **New week alignment** — add a Goal Alignment section to the weekly plan; tag tasks; flag uncovered goals
3. **Friday reflection** — summarize weekly progress per goal; surface reflection prompts and nudges

---

## Goal Storage

Goals are intentionally stored outside of any company-specific folder — they belong to you, not your employer.

Goals live at:
`{personal_root}/goals.md`

Previous quarters are archived in the same folder:
`{personal_root}/goals-{quarter}-{year}.md`
(e.g., `goals-q1-2026.md`)

### Goal File Format

```markdown
---
quarter: Q2 2026
updated: YYYY-MM-DD
---

# Personal Professional Goals — Q2 2026

## O1: [Objective — aspirational, qualitative]
**Why this matters:** [1–2 sentences on motivation and what success looks like]

- **KR1:** [Measurable key result]
- **KR2:** [Measurable key result]
- **KR3:** [Measurable key result]

## O2: [Objective]
**Why this matters:** ...

- **KR1:** ...
```

Objectives are qualitative and directional. Key Results are specific and measurable — they answer "how will I know I achieved this?"

---

## Mode 1: Update Goals (`/personal-goals`)

When the user invokes this directly or says something like "update my goals" or "quarterly goals review":

1. **Check if goals exist** — read `hub/personal-goals.md`
   - If no file: create the `personal/` directory if it doesn't exist, then guide the user to create goals from scratch (see below)
   - If file exists: show the current goals as a summary, then ask what they want to change

2. **Accept input flexibly** — the user might paste raw text from their Google Doc, dictate changes conversationally, or say "rewrite everything". Work with whatever they provide.

3. **Shape into OKR format** — if the input is unstructured, help organize it: identify the high-level aspirations (Objectives) and the specific measurable outcomes (Key Results). Ask clarifying questions if needed. A good KR is specific enough that you'd know whether it was hit or not.

4. **Quarter handling**:
   - Ask which quarter these goals apply to if unclear
   - If it's a new quarter: before saving, archive the current file to `personal-goals-q{N}-{year}.md`
   - If it's an update within the same quarter: overwrite in place, update the `updated` date

5. **Save and confirm** — write the file, then show the final goals back to the user for confirmation

**Starting fresh (no goals file yet):**
Ask the user to share their goals — paste from Google Doc, dictate, or describe. Then help structure them. A typical set has 3–5 Objectives with 2–4 Key Results each. Don't push for more than the user has; a few meaningful goals beat a laundry list.

---

## Mode 2: New Week Alignment

When triggered after `new-week` creates a weekly plan, or when the user asks to align goals with their week:

1. **Read both files**:
   - Goals: `hub/personal-goals.md`
   - Current week: `Weekly Plan/{YYYY-MM-DD}/README.md`

2. **Map tasks to goals** — scan each task in the plan. For each, ask: does this task move any Objective forward? Look for thematic alignment (e.g., a task about team coaching ladders up to a "leadership" objective; a task about architecture ladders up to a "technical depth" objective). Many operational tasks won't map — that's fine. Tag the ones that do.

3. **Add goal tags inline** — for tasks that map to a goal, add a sub-bullet:
   ```
   - [ ] **Task title**: description
       - Goal: O1 — [Objective title]
   ```

4. **Add a Goal Alignment section** to the weekly plan, inserted after `## This Week's Priorities`:

```markdown
## Goal Alignment

| Objective | Coverage | Key Tasks |
|-----------|----------|-----------|
| O1: [title] | ✅ Covered | Task A, Task B |
| O2: [title] | ⚠️ Light | Task C only |
| O3: [title] | 🔴 None | — |

### Focus Nudge
> **O3 — [title]** has no tasks this week. To move it forward, consider: [1–2 concrete suggestions drawn from its Key Results].
```

Only generate a Focus Nudge for goals with zero or very light coverage. Don't nudge every goal — that dilutes the signal.

5. **Don't force coverage** — if a week is legitimately heads-down on one or two goals, reflect that honestly. The table is a mirror, not a report card. The nudge is a gentle prompt, not a mandate.

---

## Mode 3: Weekly Review / Friday Reflection

When triggered during a weekly review, at end-of-week, or when the user says something like "how did my week track against my goals":

1. **Read both files** — goals and current week's plan

2. **Assess coverage per Objective**:
   - Which tasks (completed or attempted) connected to each goal?
   - Did the goal meaningfully advance, or just get touched?
   - Assign a status: 🟢 On Track / 🟡 At Risk / 🔴 No Activity

3. **Add a Weekly Goal Reflection section** to the weekly review or the week's README:

```markdown
## Weekly Goal Reflection

### O1: [Objective]
**Status:** 🟢 On Track
**This week:** [Tasks that contributed — be specific]
**Reflection:** What specifically moved this forward? What would accelerate it next week?

### O2: [Objective]
**Status:** 🟡 At Risk
**This week:** [Partial or indirect work]
**Reflection:** What got in the way? Is there a smaller, lower-friction step that would help?

### O3: [Objective]
**Status:** 🔴 No Activity
**Nudge:** This goal had no coverage this week. For next week, a concrete step could be: [suggestion tied to a specific KR].

---
**Overall:** Which goal feels most behind? What's one shift you could make next week to address it?
```

4. **Calibrate the tone** — reflection prompts should feel like a thoughtful conversation with yourself, not a performance review. The goal is honest self-assessment, not guilt. Frame at-risk or inactive goals as information, not failure.

---

## Integration Notes

- **After `new-week`**: Offer "Want me to add goal alignment to this week's plan?" — don't silently add it without asking
- **After `process-meeting` (weekly review)**: Offer "Want me to add a goal reflection section?"
- **If the goals file is missing**: Don't fail silently. Tell the user: "I don't see a goals file yet — want to set one up? You can paste in your Google Doc or just describe your goals."
- **If the goals file looks stale** (e.g., quarter in the frontmatter doesn't match current date): Flag it: "Your goals are from Q1 — want to update them before we run alignment?"
- **Goal mapping is fuzzy** — use judgment, not keyword matching. A task about "reviewing CDL-17 opportunities" might ladder up to a "customer impact" objective even though neither uses that word
