---
name: new-week
description: |
  Create a new weekly plan from template. Use this skill when the user asks to "create new week", "start new weekly plan", "generate next week's plan", "set up next week", or wants to create their weekly planning document.

  This skill automates weekly plan creation by:
  - Auto-calculating dates for the next week
  - Carrying over incomplete tasks from the previous week
  - Setting up the proper file structure and sections
  - Including team member activity template sections

  <example>
  Context: Friday afternoon, user wants to set up next week
  user: "Can you create next week's plan?"
  assistant: "I'll create your weekly plan for next week with carried-over tasks."
  <commentary>
  The skill will find the latest weekly plan, identify incomplete tasks, calculate next week's dates, and create a new plan file with the proper structure.
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


# New Week Skill

## Description
Creates a new weekly plan document with auto-calculated dates, sequential numbering, carried-over incomplete tasks, and team member activity sections. This skill streamlines the weekly planning process by automating repetitive setup tasks.

## Input
- No parameters required (automatically determines next week)
- Optional: User can specify a different date if not creating the immediate next week

## Instructions

### Phase 1: Find Latest Weekly Plan

1. **Locate Weekly Plan Directory**
   - Path: `{weekly_plans}/`
   - List all subdirectories in this directory

2. **Identify Most Recent Plan**
   - Folders follow pattern: `YYYY-MM-DD/` (e.g., `2026-02-09/`, `2026-02-02/`)
   - Sort directories by date to find the most recent
   - Each folder contains a `README.md` file with the weekly plan

3. **Read Previous Week's Plan**
   - Use the Read tool to load the most recent `README.md`
   - Parse the content to extract:
     - Incomplete tasks (lines with `- [ ]`)
     - The date from the title (e.g., "# Feb 9, 2026")
     - Any "Tasks For Next Week" section

### Phase 2: Calculate Next Week's Date

1. **Parse Current Week Date**
   - Extract date from the previous plan's folder name
   - Example: `2026-02-09/` → February 9, 2026

2. **Calculate Next Monday**
   - Add 7 days to get the next week's Monday
   - Format folder: `YYYY-MM-DD/` (e.g., `2026-02-16/`)
   - Format title: `# {Month} {Day}, {Year}` (e.g., `# Feb 16, 2026`)
   - Use the reference: `~/.claude/skills/new-week/references/date-formatting.md`

3. **Determine Folder Name**
   - Use ISO date format: `YYYY-MM-DD`
   - Example: Next week after 2026-02-09 is 2026-02-16

### Phase 3: Extract Carried-Over Tasks

1. **Scan ALL Sections for Incomplete Tasks**
   Search for all lines matching pattern: `- [ ]` (unchecked checkbox) in these sections:
   - **Working Tasks** (Monday through Friday sections)
   - **Carried Over from Last Week** section
   - **Follow-up Action Items** section
   - **Tasks For Next Week** section
   - **General Notes** section (including subsections like "Defects", "Innovation/Exploration")
   - **Notes-derived Action Items** section

   IMPORTANT: Do NOT stop after finding tasks in Working Tasks - scan the entire document!

2. **Deduplicate Tasks**
   - Identify duplicate or very similar tasks across sections
   - Keep the most detailed version with full context
   - Common duplicates:
     - Task in "Working Tasks" AND "Follow-up Action Items"
     - Task in multiple day sections
     - Task with slight wording variations
   - Use description similarity and URL matching to detect duplicates

3. **Categorize Tasks by Theme**
   Group tasks into categories based on keywords and context:
   - **Leadership/Strategy**: Operating model, alignment, strategic planning
   - **Architecture/Technical**: Skills Journey architecture, technical reviews, system design
   - **Labs**: Labs 2026, labs functionality, labs errors, walkthrough
   - **Product/Features**: Dynamic lecture articles, learning systems, product reviews
   - **Process/Operations**: Backlog review, support rota, guidelines
   - **Innovation/Research**: Agent-first thinking, agentic apps, experiments
   - **Meetings/Sync**: Schedule meetings, coordination, follow-ups
   - **Defects/Bugs**: Specific JIRA tickets, error investigations
   - **Reviews/Feedback**: Weekly review, documentation review

4. **Extract Rich Context**
   For each task, capture:
   - Task description (including **Category**: format if present)
   - Any sub-bullets or notes (indented lines)
   - URLs and links
   - Original context (which day/section it was in)
   - Any "Carried over from X" notes to track age
   - Priority indicators ("low priority", "critical", etc.)

5. **Prioritize Tasks**
   - Tasks from "Tasks For Next Week" are high priority
   - Critical/urgent tasks should be noted
   - Low priority tasks should be preserved but marked

### Phase 4: Distribute Tasks Across Days

1. **Assign Tasks to Days by Theme**
   Distribute the categorized tasks across Monday-Friday based on logical grouping:

   **Monday**: Leadership, Strategy, Planning
   - Operating model discussions
   - Strategic alignment meetings
   - Skills Journey architecture planning
   - Coordination with leadership

   **Tuesday**: Labs, Technical Deep Dives
   - Labs 2026 work
   - Technical reviews
   - Labs error investigations
   - Labs walkthroughs

   **Wednesday**: Product, Features, Process
   - Product feature work
   - Dynamic lecture articles
   - Learning systems
   - Backlog reviews
   - Process improvements

   **Thursday**: Innovation, Research, Exploration
   - Agent-first thinking
   - Agentic apps experiments
   - New technology exploration
   - Innovation initiatives

   **Friday**: Reviews, Wrap-up, Defects
   - Weekly review
   - Defect fixes
   - Documentation
   - Week wrap-up activities

2. **Balance Task Load**
   - Aim for 3-5 tasks per day
   - If one day has too many tasks, redistribute to adjacent days
   - Keep related tasks together when possible
   - Consider effort: mix quick tasks with longer ones

3. **Generate Daily Focus Areas**
   Based on tasks assigned to each day, create a concise focus statement:
   - Example: "**Focus: Leadership Alignment & Planning**"
   - Example: "**Focus: Labs & Technical Reviews**"

### Phase 5: Create New Weekly Plan Structure

1. **Create Folder and File**
   - Folder format: `YYYY-MM-DD/` (e.g., `2026-02-16/`)
   - File inside: `README.md`
   - Full path: `{weekly_plans}/{YYYY-MM-DD}/README.md`

2. **Build Template with Distributed Tasks**
   Use this template structure:

```markdown
# {Month} {Day}, {Year}

## This Week's Priorities

- **{Theme 1}**: {Brief description based on carried tasks}
- **{Theme 2}**: {Brief description}
- **{Theme 3}**: {Brief description}

## Working Tasks

### Monday ({M/D})

**Focus: {Generated focus for Monday}**

{Tasks assigned to Monday with full context}

### Tuesday ({M/D})

**Focus: {Generated focus for Tuesday}**

{Tasks assigned to Tuesday with full context}

### Wednesday ({M/D})

**Focus: {Generated focus for Wednesday}**

{Tasks assigned to Wednesday with full context}

### Thursday ({M/D})

**Focus: {Generated focus for Thursday}**

{Tasks assigned to Thursday with full context}

### Friday ({M/D})

**Focus: {Generated focus for Friday}**

{Tasks assigned to Friday with full context}

## Carried Over from Last Week (All Assigned Above)

All {count} incomplete tasks from {previous week date} have been distributed across the week by focus area.

## Notes-derived Action Items

(Populate as week progresses)

## Tasks For Next Week ({next week date})

## Notes

```

3. **Populate Task Details**
   For each task assigned to a day:
   - Format: `- [ ] **{Category}**: {Task description}`
   - Include sub-bullets with context (indented)
   - Add note: "Carried over from {previous week date}"
   - Preserve all URLs and links
   - Keep priority indicators if present

### Phase 6: Add Team Member Activity Sections

1. **Read Team Roster**
   - Path: `{myteam_index}`
   - Extract all team member names and roles

2. **Create Team Activity Templates**
   - Add sections for key team members or squads
   - Use this format at the end of the Notes section:

```markdown
### Team Activity Summary

#### {Pod Name} (e.g., Skills Enablement)
- **{Team Member Name}**: [Activity updates]

#### {Pod Name} (e.g., Technical Skills Mastery)
- **{Team Member Name}**: [Activity updates]
```

### Phase 7: Write and Confirm

1. **Create Directory and Write File**
   - Use Bash to create the directory: `mkdir -p "{weekly_plans}/{YYYY-MM-DD}"`
   - Use Write tool to create the README.md file inside
   - Ensure proper path: `{weekly_plans}/{YYYY-MM-DD}/README.md`
   - Verify the file was created successfully

2. **Generate Summary**
   - Report to user:
     - New folder and file path
     - Number of unique tasks carried over (after deduplication)
     - Date range for the new week
     - Task distribution by day (e.g., "Monday: 4, Tuesday: 4, etc.")
     - Summary of focus areas for each day

3. **Suggest Next Steps**
   - Recommend filling in "This Week's Priorities"
   - Suggest reviewing carried-over tasks for relevance
   - Offer to update team activity using the `update-team` skill (if available)

## Edge Cases

### Multiple Weeks Skipped
If creating a plan and more than one week has passed:
- Ask user if they want to catch up on missed weeks or skip to current week
- Only carry over tasks that are still relevant (ask if unsure)

### No Previous Plan Found
If this is the first weekly plan:
- Start with number `000`
- Create template without carried-over tasks
- Use current week's Monday as the date

### Ambiguous Tasks
If a task is unclear whether it should be carried over:
- Include it with a note: "[Review: still relevant?]"
- Let user decide during review

### Date Calculation Errors
- Verify the calculated date makes sense (not in the past, proper month/year)
- If user specifies a different date, use that instead
- Handle month/year transitions properly (Dec → Jan, year increment)

## Example Output

```markdown
# Feb 16, 2026

## This Week's Priorities

- **Operating Model & Skills Journey**: Finalize alignment with leadership
- **Labs 2026**: Push proposal forward with stakeholders
- **Dynamic Lecture Articles**: Productionalize the flow
- **Innovation**: Explore agent-first thinking and agentic apps

## Working Tasks

### Monday (2/16)

**Focus: Leadership Alignment & Planning**

- [ ] **Morgan/Drew/Quinn Sync**: Schedule and coordinate follow-up conversation on operating model
    - Carried over from Feb 9, 2026
    - Quinn's note on subs tiers aligns with thinking
- [ ] **Skills Journey Architecture**: Work with Taylor, Devon A, John W to define team ownership
    - Carried over from Feb 9, 2026
    - DS ownership aligned, product eng to follow
- [ ] **Skills Journey Model**: Share rough model mapping groups and tech leads to components
    - Carried over from Feb 9, 2026

### Tuesday (2/17)

**Focus: Labs & Technical Reviews**

- [ ] **Labs 2026 Proposal**: Keep pushing proposal forward
    - Carried over from Feb 9, 2026
    - Link: https://docs.google.com/document/d/...
- [ ] **Schedule Emerson Labs 2026 review**
    - Carried over from Feb 9, 2026
- [ ] **Labs Error Rate**: Investigate persistent error rate
    - Carried over from Feb 9, 2026

### Wednesday (2/18)

**Focus: Product & Process Improvements**

- [ ] **Dynamic Lecture Articles**: Follow up with Robin, Avery, Jamie
    - Carried over from Feb 9, 2026
- [ ] **Learning Systems Review**: Review learning paths, share resource
    - Carried over from Feb 9, 2026
- [ ] **Backlog Review**: Review backlog
    - Carried over from Feb 9, 2026

### Thursday (2/19)

**Focus: Innovation & Exploration**

- [ ] **Agent-First Thinking**: Ideate on how to get teams thinking agent-first
    - Carried over from Feb 9, 2026
    - Review: https://x.com/gdb/status/...
- [ ] **Data Platform Agentic App**: Try agentic app approach
    - Carried over from Feb 9, 2026

### Friday (2/20)

**Focus: Wrap-up & Defect Resolution**

- [ ] **Weekly Review**: Reflect on week's progress
    - Carried over from Feb 9, 2026
    - Review completed vs. planned tasks
- [ ] **Defect LS-668**: Fix events being rejected
    - Carried over from Feb 9, 2026

## Carried Over from Last Week (All Assigned Above)

All 17 incomplete tasks from Feb 9 have been distributed across the week by focus area.

## Notes-derived Action Items

(Populate as week progresses)

## Tasks For Next Week (Feb 23)

## Notes

```

## Tools to Use

- **Read**: Read previous weekly plan and team roster
- **Write**: Create the new weekly plan file
- **Bash**: Execute date calculation and file listing commands
- **Grep**: Search for incomplete tasks across multiple files if needed

## Best Practices

- Always verify the date calculation is correct
- Preserve task context and links when carrying over
- Don't carry over completed tasks (marked with `[x]`)
- Keep the structure consistent with previous weeks
- Include all relevant information from carried-over tasks
- Consider grouping similar tasks together in the carried-over section

## Related Skills

- **track-actions**: Use this to see all pending action items across multiple weeks
- **update-team**: Use this to populate team member activity after creating the plan

## Common Usage Patterns

1. **End of Week Planning**
   ```
   user: "Create next week's plan"
   skill: Generates plan for upcoming Monday with all incomplete tasks
   ```

2. **Mid-Week Catch-Up**
   ```
   user: "I missed creating this week's plan, can you make one for this week?"
   skill: Creates plan for current week with relevant tasks
   ```

3. **Preview Before Creating**
   ```
   user: "Show me what would be carried over to next week"
   skill: Lists incomplete tasks without creating the file yet
   ```
