---
name: track-actions
description: |
  Aggregate and track all open action items across recent weekly plans. Use this skill when the user asks to "track action items", "show open tasks", "what's pending", "list my todos", "show incomplete tasks", or wants to see all action items from their weekly plans.

  This skill scans recent weekly plans, extracts open action items, calculates how long they've been pending, and generates a comprehensive dashboard grouped by owner, category, or priority.

  <example>
  Context: User wants to see all pending action items
  user: "Show me all my open action items"
  assistant: "I'll scan your recent weekly plans and create an action items dashboard."
  <commentary>
  The skill will read the last 4-8 weeks of weekly plans, extract unchecked tasks, calculate their age, and present them in a organized dashboard format.
  </commentary>
  </example>
---

## Setup: Resolve Config Paths

Before any file operation, resolve `{placeholder}` references in this file:

1. Read `plugins/weekly-planning/config.local.json` (fall back to `config.example.json` if missing).
2. Substitute each `{placeholder}` with the matching key from the config. Top-level keys (e.g. `docs_root`, `templates_root`, `personal_root`) and `subpaths` keys (e.g. `weekly_plans`, `meeting_notes`, `hub`, `teammembers`, `myteam_index`, `notes_template`, `goals_file`) are valid.
3. Subpath values may themselves reference `{docs_root}` etc. — expand recursively.
4. Tilde (`~`) at the start of a path expands to `$HOME`.

If `config.local.json` is missing, tell the user to copy `config.example.json` to `config.local.json` and fill in their paths before continuing.


# Track Actions Skill

## Description
Scans recent weekly plans to extract all open action items, calculates their age, identifies owners, and generates a comprehensive dashboard. This helps track what's still pending across multiple weeks and prioritize work.

## Input
- No parameters required (automatically scans last 8 weeks)
- Optional: User can specify number of weeks to scan
- Optional: Filter by person, category, or priority

## Instructions

### Phase 1: Locate and Read Weekly Plans

1. **Find Weekly Plan Folders**
   - Directory: `{weekly_plans}/`
   - List all subdirectories matching pattern: `YYYY-MM-DD/` (e.g., `2026-02-09/`)
   - Sort by folder name (descending) to get most recent first

2. **Determine Scan Window**
   - Default: Last 8 weeks of plans
   - If user specifies a different window, use that
   - Calculate which folders to read based on current date and folder dates

3. **Read Each Weekly Plan**
   - Use Read tool to load each `README.md` file from the folders
   - Parse the title to extract the week date (e.g., "# Feb 9, 2026")
   - Store folder path and date for reference

### Phase 2: Extract Open Action Items

1. **Scan for Unchecked Tasks**
   - Pattern to match: `- [ ]` (checkbox with space = unchecked)
   - Do NOT match: `- [x]` (checked = completed)
   - Extract the full line including any description

2. **Parse Task Details**
   For each unchecked task, extract:
   - **Task description**: The text after `- [ ]`
   - **Category/Project**: Often marked with `**Category**:` format
     - Examples: `**Labs**:`, `**GwG**:`, `**Review**:`, `**Agentic AI**:`
   - **Owner**: Look for names or team indicators
     - Explicit: "Jordan:", "Riley:", "Sam:"
     - Implied: If in a specific day section, likely owned by the user
   - **Links**: Any URLs in the task description
   - **Context**: Which day section it appears in (Monday, Tuesday, etc.)
   - **Priority indicators**: Words like "critical", "urgent", "low priority", "ASAP"

3. **Handle Multi-line Tasks**
   - Tasks may have sub-bullets (indented with spaces or tabs)
   - Include sub-bullets as part of the task context
   - Example:
     ```
     - [ ] **Labs**: Follow through on work
         - Carried over from 1/20
         - Asked for clarification
     ```

4. **Extract Carried-Over Notes**
   - Look for phrases like "Carried over from {date}"
   - This helps determine the original age of the task

5. **Use Action Item Patterns**
   - Reference: `~/.claude/skills/track-actions/references/action-item-patterns.md`
   - Common patterns for identifying owners and priorities

### Phase 3: Calculate Task Age

1. **Determine First Appearance**
   - For each task, find the earliest week it appeared
   - If task has "Carried over from X" note, use that date
   - Otherwise, use the week where it first appears in the scan window

2. **Calculate Age in Weeks**
   - Difference between first appearance and current date
   - Format: "X weeks old" or "X days old" for recent tasks
   - Use script: `~/.claude/skills/track-actions/scripts/calculate_age.sh`

3. **Age Categories**
   - 🟢 Fresh (0-1 weeks): Just added
   - 🟡 Active (2-3 weeks): In progress, reasonable age
   - 🟠 Aging (4-6 weeks): Getting old, needs attention
   - 🔴 Stale (7+ weeks): Very old, likely blocked or forgotten

### Phase 4: Categorize and Group

1. **Group by Owner**
   - Extract owner from task description or context
   - Default owner: The user (Alex Chen) if not specified
   - Use team roster to validate names: `{myteam_index}`
   - Group tasks by:
     - Alex Chen (self)
     - Jordan Patel
     - Sam Lee
     - Riley Kim (Riley)
     - Other team members
     - Unassigned

2. **Group by Category/Project**
   - Common categories from tasks:
     - GwG (Grow with Google)
     - Labs
     - CTE (Course Taking Experience)
     - Skills Journey
     - Agentic AI
     - Reviews
     - Team Management
     - Strategy
     - Meetings
     - Other

3. **Group by Priority**
   - **Critical**: Tasks with words like "urgent", "critical", "blocker", "ASAP"
   - **High**: Tasks with deadlines, explicit priorities, or important projects
   - **Medium**: Most regular tasks
   - **Low**: Tasks marked "low priority" or "when time permits"

### Phase 5: Generate Dashboard

1. **Create Summary Header**
```markdown
# Action Items Dashboard
Generated: {current date}
Scanned: {number} weekly plans from {earliest date} to {latest date}

## Summary
- **Total Open Items**: {count}
- **By Age**:
  - 🟢 Fresh (0-1 weeks): {count}
  - 🟡 Active (2-3 weeks): {count}
  - 🟠 Aging (4-6 weeks): {count}
  - 🔴 Stale (7+ weeks): {count}
```

2. **By Owner Section**
```markdown
## By Owner

### Alex Chen ({count} items)
- [ ] **{Category}**: {Task description} ({age} old) - [Week {date}](/path/to/plan.md)
- [ ] **{Category}**: {Task description} ({age} old) - [Week {date}](/path/to/plan.md)

### Jordan Patel ({count} items)
- [ ] **{Category}**: {Task description} ({age} old) - [Week {date}](/path/to/plan.md)

### [Other team members...]
```

3. **By Category Section**
```markdown
## By Category

### GwG - Grow with Google ({count} items)
- [ ] {Task} - Owner: {name} ({age} old) - [Week {date}](/path/to/plan.md)

### Labs ({count} items)
- [ ] {Task} - Owner: {name} ({age} old) - [Week {date}](/path/to/plan.md)

### [Other categories...]
```

4. **By Priority Section**
```markdown
## By Priority

### 🔴 Critical ({count} items)
- [ ] {Task} - Owner: {name} ({age} old) - [Week {date}](/path/to/plan.md)

### 🟠 High ({count} items)
- [ ] {Task} - Owner: {name} ({age} old) - [Week {date}](/path/to/plan.md)

### 🟡 Medium ({count} items)
[Show count only, don't list all items to avoid overwhelming]

### 🟢 Low ({count} items)
[Show count only]
```

5. **Stale Items Alert**
```markdown
## ⚠️ Stale Items (7+ weeks old)

These items have been pending for a long time and may need review:

- [ ] {Task} - Owner: {name} ({age} old) - [Week {date}](/path/to/plan.md)
  - **Action Needed**: Consider closing, delegating, or prioritizing this task
```

### Phase 6: Insights and Recommendations

1. **Provide Insights**
   - Identify bottlenecks (categories with many old items)
   - Highlight overloaded owners
   - Flag items with no clear owner
   - Note recurring tasks across multiple weeks

2. **Suggest Actions**
   ```markdown
   ## Recommendations

   - 📊 **{Category}** has {count} items aging 4+ weeks. Consider prioritizing or delegating.
   - 👤 **{Owner}** has {count} items. May need to review capacity or redistribute work.
   - ⚠️ {count} items have no clear owner. Assign owners for better tracking.
   - 🔄 {count} items have been carried over 3+ times. Consider if they're still relevant.
   ```

3. **Quick Actions**
   - Suggest which tasks to tackle this week
   - Recommend tasks that can be closed or delegated
   - Identify quick wins (simple tasks to complete)

## Output Format

The dashboard should be clear, actionable, and scannable. Use:
- ✅ Checkboxes for all tasks (allows copying to weekly plan)
- 📅 Age indicators with color coding
- 🔗 Links to source weekly plans
- 📊 Summary statistics
- 🎯 Clear grouping and categorization

## Edge Cases

### Duplicate Tasks
If the same task appears in multiple weeks:
- Count it only once
- Use the earliest appearance for age calculation
- Note: "Appeared in {count} weeks"

### Tasks Without Clear Categories
- Group under "Other" or "Miscellaneous"
- Try to infer category from context

### Very Old Tasks (12+ weeks)
- Highlight prominently
- Suggest user review: still relevant? Can it be closed?

### Empty Weeks
- If a week has no unchecked tasks, skip it (don't list)
- Note in summary: "{count} weeks with no pending items"

### Tasks in Different Sections
- Tasks may appear in different sections (Working Tasks, Carried Over, Notes-derived)
- Treat all unchecked tasks equally regardless of section

## Tools to Use

- **Read**: Read weekly plan files
- **Grep**: Search for unchecked tasks: `grep -n "^- \[ \]"`
- **Glob**: Find all weekly plan files: `Weekly Plan/*.md`
- **Bash**: Execute age calculation scripts, count tasks

## Best Practices

- Be accurate with age calculations
- Preserve all task context (links, notes, sub-bullets)
- Don't drop information when summarizing
- Make links clickable for easy navigation
- Use clear visual hierarchy (headers, lists, emphasis)
- Highlight critical/stale items prominently
- Keep dashboard scannable (don't overwhelm with too much detail)

## Related Skills

- **new-week**: After reviewing action items, create next week's plan
- **update-team**: Get team activity context for task prioritization

## Example Usage Patterns

1. **Weekly Review**
   ```
   user: "Show me all open action items before I plan next week"
   skill: Generates comprehensive dashboard for review
   ```

2. **Quick Check**
   ```
   user: "What tasks have I been carrying over for more than a month?"
   skill: Filters to show only stale items (4+ weeks)
   ```

3. **Team View**
   ```
   user: "What action items are assigned to my team members?"
   skill: Groups by team member with their pending tasks
   ```

4. **Category Focus**
   ```
   user: "Show me all Labs-related action items"
   skill: Filters dashboard to Labs category only
   ```

## Integration Notes

This skill works best when:
- Weekly plans follow consistent format
- Tasks use clear ownership/category markers
- Plans are regularly updated and maintained
- Used in conjunction with new-week skill for planning workflow
