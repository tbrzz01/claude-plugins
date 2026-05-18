---
name: leadership-review
description: |
  Run structured weekly and monthly leadership reviews with persistent feedback, trend tracking, and a monthly scorecard. Use this skill when the user says "weekly review", "monthly review", "leadership review", "review the week", "review the month", "show me the review format", "give me the weekly review template", or otherwise indicates they want to do a structured leadership reflection.

  Also use this skill PROACTIVELY when the user is finishing a weekly review near the end of the calendar month and no monthly review exists for the current month — in that case, prompt them to also do a monthly review.

  This skill handles:
  - Serving the exact weekly/monthly templates verbatim when the user wants to fill one out
  - Saving filled reviews under `{leadership_reviews}/weekly/` or `{leadership_reviews}/monthly/`
  - Generating qualitative feedback after each review
  - Tracking week-over-week and month-over-month patterns in a running trends log
  - Generating a Monthly Leadership Scorecard after each monthly review
  - Prompting for an overdue monthly review

  <example>
  Context: User wants to start their weekly leadership reflection
  user: "Give me the weekly review format"
  assistant: "I'll use the leadership-review skill to serve the weekly review template."
  <commentary>
  The skill outputs the WEEKLY_REVIEW template verbatim. The user fills it in and pastes it back, then the skill saves, gives feedback, and updates the trends log.
  </commentary>
  </example>

  <example>
  Context: User pastes a completed monthly review
  user: "Here's my monthly review: ## Monthly Review ### 1. Biggest Wins..."
  assistant: "I'll use the leadership-review skill to save this, generate feedback, and produce your Monthly Leadership Scorecard."
  <commentary>
  The skill recognizes the filled MONTHLY_REVIEW format, saves it under monthly/YYYY-MM.md, appends to trends.md, and generates the scorecard.
  </commentary>
  </example>
---

## Setup: Resolve Config Paths

Before any file operation, resolve `{placeholder}` references in this file:

1. Read `plugins/weekly-planning/config.local.json` (fall back to `config.example.json` if missing).
2. Substitute each `{placeholder}` with the matching key from the config. Top-level keys (e.g. `docs_root`, `templates_root`, `personal_root`) and `subpaths` keys (e.g. `weekly_plans`, `meeting_notes`, `hub`, `teammembers`, `myteam_index`, `notes_template`, `goals_file`, `leadership_reviews`) are valid.
3. Subpath values may themselves reference `{docs_root}` etc. — expand recursively.
4. Tilde (`~`) at the start of a path expands to `$HOME`.

If `config.local.json` is missing, tell the user to copy `config.example.json` to `config.local.json` and fill in their paths before continuing.

If `leadership_reviews` is not present in the config, default to `{personal_root}/leadership-reviews` and tell the user (once) that they may want to add it explicitly.

## Storage Layout

All reviews live under `{leadership_reviews}/`:

```
{leadership_reviews}/
├── weekly/
│   └── YYYY-MM-DD.md           # one file per week, dated to the Monday of that week
├── monthly/
│   └── YYYY-MM.md              # one file per calendar month (review + scorecard in same file)
└── trends.md                    # running log of feedback, patterns, deltas over time
```

Create directories with `mkdir -p` as needed — do not assume they exist.

## How to Recognize User Intent

The user can enter this skill in five distinct ways. Identify which one before acting:

1. **Asking for the weekly format** — phrases like "show me the weekly review", "give me the weekly review template/format", "what's the weekly review format", "I want to do my weekly review" *without* providing any content yet. → Go to **Workflow A: Serve Weekly Template**.

2. **Submitting a filled weekly review** — message contains the `<WEEKLY_REVIEW>` tag or recognizable section headings (`### 1. Top Outcomes`, `### 2. What Actually Mattered`, etc.) with content filled in. → Go to **Workflow B: Process Weekly Review**.

3. **Asking for the monthly format** — phrases like "show me the monthly review", "give me the monthly review template/format", "I want to do my monthly review" *without* content. → Go to **Workflow C: Serve Monthly Template**.

4. **Submitting a filled monthly review** — message contains the `<MONTHLY_REVIEW>` tag or `## Monthly Review` with filled subsections. → Go to **Workflow D: Process Monthly Review**.

5. **Generic "leadership review" with no content and no qualifier** — ambiguous between weekly and monthly. Ask: "Weekly or monthly?" before continuing.

If the user pastes raw content that doesn't clearly match either format (e.g., free-form reflections), ask whether to treat it as weekly or monthly, or whether they'd prefer to use the structured template instead.

## Workflow A: Serve Weekly Template

When the user asks for the weekly review format without providing content:

1. Read `templates/weekly-review.md` (sibling to this SKILL.md).
2. Output its contents verbatim — preserve the `<WEEKLY_REVIEW>` tags, numbering, dashes, and spacing exactly.
3. After the template, add a brief line: "Fill this in and paste it back. I'll save it, give feedback, and update your trends log."
4. Stop. Do not save anything yet.

## Workflow B: Process Weekly Review

When the user submits a filled weekly review:

### Step 1: Determine the week-of date

The weekly review applies to the calendar week ending. Compute the Monday of that week:

- If the user submits on a Friday/Saturday/Sunday → use the Monday of that same week.
- If the user submits on a Mon/Tue/Wed/Thu → assume they're reviewing the *previous* week, use the Monday of the prior week.
- If unclear or boundary case, ask the user which week this review covers.

Format the date as `YYYY-MM-DD`. This becomes the filename.

### Step 2: Save the review

1. Path: `{leadership_reviews}/weekly/YYYY-MM-DD.md`
2. Run `mkdir -p {leadership_reviews}/weekly` first.
3. If a file already exists for that week, ask the user whether to overwrite, append, or save as a versioned file (`YYYY-MM-DD-v2.md`). Do not silently overwrite.
4. Write the user's review content as-is (including the `<WEEKLY_REVIEW>` tags if present), with a frontmatter block at the top:

```markdown
---
type: weekly-review
week_of: YYYY-MM-DD
created: YYYY-MM-DD
---

{user's review content}
```

### Step 3: Read prior weekly reviews for context

Read the most recent 2–4 weekly reviews from `{leadership_reviews}/weekly/` (sorted by date, descending, excluding the one you just saved). These give you the longitudinal view needed for honest feedback.

If there are no prior reviews, skip the comparison parts in Step 4 — this is the user's first one.

### Step 4: Generate feedback

Respond in the conversation (not to a file) with structured, honest feedback. Use these sections, but only include the ones that have substance — do not pad:

```markdown
## Feedback on this week's review

### Patterns I notice this week
{2–4 observations about what stands out in THIS review: clarity of priorities, conviction of decisions, honesty about growth edges, etc.}

### Compared to prior weeks
{Concrete deltas. Examples:
- "Last 3 weeks you listed 'finalize operating model' as a top outcome — this week it's still pending. Worth interrogating whether it's actually stuck or whether the framing is wrong."
- "Your 'leadership leverage' answers have shifted from 'stepped in too much' (weeks of X, Y) to 'didn't push enough' (this week) — possible overcorrection?"
- "Decisions forced this week vs. avoided: trending in the right direction over the last 3 reviews."}

### What I'd push you on
{1–3 sharp questions. The goal is to surface things the review doesn't directly say. Examples:
- "You named risk X but the 'what will I do next week' answer is generic — what's the specific first step?"
- "Section 8 (Show vs Tell) is empty again. Three weeks in a row. Is demoing actually a priority or a slot to drop?"}

### Suggested focus for next week
{Tie back to Section 3 priorities. Note if priorities are too vague, too many, or duplicates of prior weeks.}
```

Be direct. The user explicitly wants honest pattern-tracking, not encouragement. Avoid hedging language like "you might consider" — say "consider" or "do this."

### Step 5: Append to trends log

Append a compact entry to `{leadership_reviews}/trends.md`. Create the file if it doesn't exist with this header:

```markdown
# Leadership Review Trends Log

Running log of patterns, deltas, and observations from weekly and monthly reviews. Most recent at top.

---
```

Prepend (insert at the top, just under the `---`) a new entry in this format:

```markdown
## Weekly — YYYY-MM-DD

**Top outcomes claimed:** {one-line summary}
**Next week priorities:** {one-line summary}
**Risks called out:** {brief}
**Patterns / deltas:** {1–3 bullets — the meaty observations from your feedback}
**Open questions / unresolved:** {anything carried for 2+ weeks}

---
```

Keep this terse — the trends log is meant to be scannable across many weeks. Don't dump the whole feedback; capture only what's useful longitudinally.

### Step 6: Check whether to prompt for a monthly review

After saving the weekly review, decide whether to nudge for a monthly review.

**Trigger the nudge when ALL of:**
- The week being reviewed (`week_of`) is in the final 7 days of its calendar month — i.e., the Monday's date is within the last 7 days of that month. (Note: this is one heuristic; the simpler rule "the week being reviewed contains the last day of a month" also works.)
- No file exists at `{leadership_reviews}/monthly/YYYY-MM.md` for the month the weekly belongs to.

When triggered, append to your response:

```markdown
---

📅 **Monthly review reminder:** This was your last weekly review of {Month YYYY}, and I don't see a monthly review for this month yet. Want to do one now? Just say "monthly review" and I'll serve the template.
```

## Workflow C: Serve Monthly Template

When the user asks for the monthly review format without providing content:

1. Read `templates/monthly-review.md`.
2. Output its contents verbatim.
3. Add: "Fill this in and paste it back. I'll save it, give feedback, generate your Monthly Leadership Scorecard, and update your trends log."
4. Stop.

## Workflow D: Process Monthly Review

When the user submits a filled monthly review:

### Step 1: Determine the month

The monthly review covers the calendar month most recently completed:

- If submitted on or after the 1st of a month → most likely reviewing the prior month. Confirm if ambiguous.
- If submitted mid-month → ask which month they're reviewing (current vs prior).

Format as `YYYY-MM`. This becomes the filename.

### Step 2: Save the review

1. Path: `{leadership_reviews}/monthly/YYYY-MM.md`
2. `mkdir -p {leadership_reviews}/monthly`
3. If a file exists for that month, ask before overwriting.
4. Write with frontmatter:

```markdown
---
type: monthly-review
month: YYYY-MM
created: YYYY-MM-DD
---

{user's monthly review content}
```

### Step 3: Read prior context

Read:
- The last 1–2 monthly reviews from `{leadership_reviews}/monthly/`
- The last 4 weekly reviews from `{leadership_reviews}/weekly/`

The weeklies are crucial — they ground the monthly review in week-by-week reality and help you spot whether the monthly narrative matches what was actually happening week-to-week.

### Step 4: Generate feedback

Respond in conversation:

```markdown
## Feedback on this month's review

### Pattern check against your weekly reviews
{Did the monthly's "biggest wins" actually show up as outcomes in the weeklies? Are the "repeated friction patterns" consistent with what you flagged week-to-week, or is the monthly missing something the weeklies kept surfacing?}

### Compared to prior month(s)
{Concrete month-over-month deltas. Repeated friction? Strategic progress claims that haven't moved? Leadership growth areas that keep appearing?}

### Sharp questions
{1–3 things the monthly underclaims, overclaims, or dodges.}

### Themes carrying into next month
{What from this month feeds into Section 9 priorities? Are next month's priorities a continuation, a pivot, or a wish list disconnected from the rest of the review?}
```

### Step 5: Generate the Monthly Leadership Scorecard

This is required after every monthly review.

1. Read `templates/monthly-scorecard.md` for the exact structure.
2. Fill in each of the 9 dimensions with:
   - **Score (1–5)**: Your honest assessment based on the monthly review content AND the weekly reviews from this month. Do not score everything in the middle — be willing to give 2s and 5s when warranted.
   - **Notes**: 1–3 sentences citing specific evidence from the reviews. Do not be generic. Example for Decision Making: "Score: 3. You named 'forced the operating model decision' as a win, but two weeklies flagged unclear ownership decisions that weren't resolved. Trending up, not there yet."
3. Compute the **Overall Score** as the average of the 9 dimensions (one decimal place) and add a one-line gut-check summary.
4. Fill in **Key Takeaways** — 2–3 things done well and 2–3 things to improve, drawn from the actual review.
5. Fill in **One Commitment** — pull the most actionable behavioral change from the review or, if absent, propose one and clearly mark it as a suggestion: "(Suggested — confirm or adjust)".

Append the completed scorecard to the same file you saved in Step 2, after the user's review content, separated by a clear `---` divider:

```markdown
---

## Monthly Leadership Scorecard ({Month YYYY})

{filled-in scorecard with all 9 dimensions, overall score, takeaways, commitment}
```

Also display the scorecard in the conversation so the user sees it immediately.

### Step 6: Append to trends log

Prepend a monthly entry to `{leadership_reviews}/trends.md`:

```markdown
## Monthly — YYYY-MM

**Biggest wins:** {one-line}
**Repeated friction patterns:** {one-line}
**Scorecard overall:** {X.X / 5} — {one-line gut summary}
**Commitment:** {the One Commitment}
**Next month focus:** {one-line summary of Section 9}
**Month-over-month deltas:** {1–3 bullets}

---
```

## When the user asks "give me the format" — both at once

If the user is ambiguous ("give me the review format"), default to the **weekly** template and mention the monthly is also available: "Here's the weekly review format. If you want the monthly format instead, say 'monthly review format'."

## Edge cases and judgment calls

### First-ever review
No prior context to compare against. Skip "compared to prior weeks/months" sections in feedback. Note in the trends log: "First entry."

### User submits a partial review
If many sections are blank: save it anyway, but in feedback call out the empty sections and ask if they were intentional or rushed. Don't refuse to save.

### User submits review content but it's clearly free-form (didn't use the template)
Ask whether to (a) save it as-is, (b) help them re-cast it into the template, or (c) discard. Don't auto-restructure their writing.

### Trends log getting long
Once `trends.md` exceeds ~500 lines, suggest the user archive older entries (e.g., move entries older than 6 months into `trends-archive-YYYY.md`). Don't archive automatically.

### User asks to skip the scorecard
Respect it. Save the monthly review, generate the feedback, skip Step 5. Note in trends log: "Scorecard skipped by user."

### Conflicting dates / explicit override
If the user explicitly says "this is for the week of X" or "for the month of Y", trust them over any heuristic.

## Tone and feedback principles

The user wants honest pattern-tracking. Apply these:

- **Be specific.** "Section 6 has been blank for 3 weeks" is more useful than "consider engaging Section 6 more."
- **Cite evidence.** Quote or paraphrase the user's own words from prior reviews when calling out patterns.
- **Don't flatter.** If a week was thin, say so. The user is explicitly using this skill to surface things they might miss.
- **Don't lecture.** Frame observations and questions, not prescriptions. The user makes the call.
- **Keep feedback scannable.** Use the headings above. Avoid wall-of-text paragraphs.

## Files in this skill

- `SKILL.md` — this file
- `templates/weekly-review.md` — exact WEEKLY_REVIEW template, served verbatim
- `templates/monthly-review.md` — exact MONTHLY_REVIEW template
- `templates/monthly-scorecard.md` — MONTHLY_SCORECARD structure used as the basis for the generated scorecard

## Related skills and agents

- `new-week` — creates next week's plan. After a weekly review, often the natural next step.
- `weekly-review` agent — does an analytical wrap-up of the *work* in the current weekly plan (tasks, completion rates, team activity). Distinct from this skill, which is about *personal leadership reflection*. They complement each other.
- `personal-goals` — quarterly OKR-style goals. When generating feedback, optionally check whether weekly/monthly priorities ladder up to current goals.
