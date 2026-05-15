---
name: process-meeting
description: |
  Extract and organize action items, decisions, and next steps from meeting transcripts. Use this skill when the user asks to "process this meeting", "extract action items", "parse meeting notes", "summarize this transcript", or provides lengthy meeting content that needs to be structured.

  This skill transforms raw meeting transcripts into actionable documentation with clear owners, decisions, and next steps.

  <example>
  Context: User provides a meeting transcript after a strategy discussion
  user: "Can you process the notes from today's architecture meeting and extract the action items?"
  assistant: "I'll process the meeting transcript and create structured notes with action items, decisions, and next steps."
  <commentary>
  The skill will parse the transcript, identify action items with owners, extract key decisions, and generate a structured markdown document using the notes template.
  </commentary>
  </example>
version: 1.0.0
---

## Setup: Resolve Config Paths

Before any file operation, resolve `{placeholder}` references in this file:

1. Read `plugins/weekly-planning/config.local.json` (fall back to `config.example.json` if missing).
2. Substitute each `{placeholder}` with the matching key from the config. Top-level keys (e.g. `docs_root`, `templates_root`, `personal_root`) and `subpaths` keys (e.g. `weekly_plans`, `meeting_notes`, `hub`, `teammembers`, `myteam_index`, `notes_template`, `goals_file`) are valid.
3. Subpath values may themselves reference `{docs_root}` etc. — expand recursively.
4. Tilde (`~`) at the start of a path expands to `$HOME`.

If `config.local.json` is missing, tell the user to copy `config.example.json` to `config.local.json` and fill in their paths before continuing.


# Process Meeting Skill

## Description
Transforms meeting transcripts into structured, actionable documentation by extracting action items, decisions, next steps, and key discussion points. This skill handles both pre-structured notes and raw transcripts.

## Input
- Meeting transcript (text or markdown)
- Optional: Meeting title, date, attendees
- Optional: Meeting type (1:1, team meeting, architecture review, etc.)

## Instructions

### Phase 1: Parse Meeting Content

1. **Identify Meeting Structure**
   - Check if the transcript is already structured (has sections like "Quick recap", "Next steps", "Summary")
   - If structured: Extract existing sections and enhance them
   - If unstructured: Parse raw text to identify components

2. **Extract Basic Metadata**
   - **Title**: Meeting subject or purpose
   - **Date**: When the meeting occurred
   - **Attendees**: Who participated (names and roles if available)
   - **Duration**: How long the meeting lasted (if mentioned)
   - **Meeting Type**: 1:1, team meeting, architecture review, planning session, etc.

3. **Identify Content Sections**
   Look for these patterns in the text:
   - **Action items**: "Next steps", "Action items", "TODO", "Follow up", "Schedule", "Create", "Complete"
   - **Decisions**: "Decided", "Agreed", "Chose", "Will do", "Committed to"
   - **Discussions**: "Discussed", "Explored", "Reviewed", "Talked about"
   - **Blockers**: "Blocked by", "Waiting on", "Issue", "Problem", "Challenge"
   - **Key points**: Important statements, concerns, or insights

### Phase 2: Extract Action Items

1. **Scan for Action Patterns**
   Look for phrases indicating actions:
   - Imperatives: "Create", "Schedule", "Review", "Update", "Send", "Share", "Complete"
   - Future commitments: "will", "should", "need to", "going to"
   - Explicit assignments: "X will Y", "X to Y", "X: Y"

2. **Parse Action Item Details**
   For each action item, extract:
   - **Description**: What needs to be done
   - **Owner**: Who is responsible (explicit or inferred)
   - **Deadline**: When it's due (if mentioned)
   - **Context**: Why it's needed or related discussions
   - **Dependencies**: What it depends on or what depends on it
   - **Priority**: Urgency indicators (ASAP, urgent, high priority, etc.)

3. **Infer Owners**
   Rules for determining ownership:
   - **Explicit**: "Alex will create the document"
   - **Implied by role**: "PM should review" → assign to PM attendee
   - **Implied by domain**: "Update the labs document" → assign to person working on labs
   - **Default**: If unclear, mark as "Unassigned" or assign to meeting organizer
   - Use script: `~/.claude/skills/process-meeting/scripts/infer_owner.sh`

4. **Format Action Items**
   ```markdown
   - [ ] **{Owner}**: {Action description}
       - Deadline: {date or timeframe}
       - Context: {why or related discussion}
       - Dependencies: {blockers or related items}
       - Link: {URL if relevant}
   ```

### Phase 3: Extract Decisions

1. **Identify Decision Points**
   Look for patterns indicating decisions were made:
   - "Decided to", "Chose", "Will go with", "Agreed on"
   - "The decision is", "We'll use", "Selected"
   - Alternatives mentioned followed by chosen option

2. **Parse Decision Details**
   For each decision, extract:
   - **What was decided**: The choice or conclusion
   - **Rationale**: Why this was chosen
   - **Alternatives considered**: Other options discussed
   - **Impact**: What this affects or changes
   - **Stakeholders**: Who was involved in the decision

3. **Format Decisions**
   ```markdown
   - **Decision**: {What was decided}
     - **Rationale**: {Why}
     - **Alternatives**: {Other options considered}
     - **Impact**: {What this affects}
     - **Decided by**: {Key decision makers}
   ```

### Phase 4: Extract Next Steps

1. **Identify Future Activities**
   Look for mentions of:
   - Follow-up meetings or syncs
   - Upcoming milestones or deadlines
   - Dependencies waiting to be resolved
   - Reviews or approvals needed

2. **Format Next Steps**
   ```markdown
   - {Activity or milestone} - {Timeframe}
     - Owner: {Who}
     - Prerequisites: {What needs to happen first}
   ```

### Phase 5: Generate Structured Output

1. **Use Notes Template**
   Load template from: `{templates_root}/notes.md`

   Template structure:
   ```yaml
   ---
   title: {TITLE}
   date: {DATE_ISO}
   week: {WEEK_ID}
   type: work-note
   links:
     weekly: {WEEKLY_RELATIVE_PATH}
   ---

   # {TITLE}
   **Date:** {DATE}
   **Attendees:** {ATTENDEE_LIST}
   **Context:** {BRIEF_OVERVIEW}

   ## Goals
   {What the meeting aimed to accomplish}

   ## Decisions
   {Key decisions with rationale}

   ## Action Items
   {Formatted action items with owners}

   ## Next Steps
   {Upcoming activities and milestones}

   ## Notes
   {Additional context, key points, or discussion summaries}
   ```

2. **Populate Template Sections**
   - **Title**: Use meeting name or generate from topic
   - **Date**: Format as ISO date (YYYY-MM-DD)
   - **Week ID**: Calculate current week (e.g., "2026-02-23")
   - **Attendees**: List all participants with roles if known
   - **Context**: 1-2 sentence summary of meeting purpose

3. **Add Rich Context**
   - Include links to related documents (Google Docs, Confluence, Jira, GitHub)
   - Cross-reference related meetings or decisions
   - Add tags for easy searching (e.g., #architecture, #labs, #gwg)

### Phase 6: Link to Weekly Plan

1. **Suggest Action Item Placement**
   For each action item, suggest which day of the current week it should be added:
   - **Monday**: Strategic planning, leadership alignment
   - **Tuesday**: Technical deep dives, architecture
   - **Wednesday**: Product features, process improvements
   - **Thursday**: Innovation, research, experiments
   - **Friday**: Reviews, wrap-up, defects

2. **Generate Copy-Paste Format**
   Provide action items in a format ready to paste into the weekly plan:
   ```markdown
   ### Monday (M/D)
   - [ ] **{Owner}**: {Action description}
       - From meeting: {Meeting title} on {Date}
       - Context: {Brief context}
   ```

3. **Check for Duplicates**
   - Compare extracted action items with current week's plan
   - Flag potential duplicates for user review
   - Suggest consolidation if similar tasks exist

### Phase 7: Summary and Output

1. **Generate Summary**
   Create a brief summary including:
   - **Meeting Type**: What kind of meeting it was
   - **Key Outcomes**: Top 3-5 takeaways
   - **Action Items Count**: Total action items by owner
   - **Decision Count**: How many decisions were made
   - **Follow-up Needed**: Any immediate next steps

2. **Output Structured Document**
   - Save to appropriate location (if specified)
   - Or return formatted markdown for user to save
   - Include metadata for future reference

3. **Suggest Follow-ups**
   - Recommend scheduling follow-up meetings if needed
   - Suggest adding to calendar for deadline tracking
   - Offer to create Jira tickets for larger action items

## Edge Cases

### Pre-structured Notes
If the transcript already has sections:
- Preserve existing structure
- Enhance with additional parsing
- Fill in missing sections (e.g., add Decisions if only Actions exist)

### Multiple Meetings in One Transcript
If the text contains multiple meetings:
- Ask user to clarify which meeting to process
- Or process each separately and generate multiple documents

### Unclear Ownership
If action items lack clear owners:
- Mark as "[Unassigned]"
- Suggest potential owners based on:
  - Domain expertise (labs → labs team lead)
  - Role (PM → product decisions, Eng → technical tasks)
  - Past meetings (who handled similar tasks before)

### Very Long Transcripts
If the transcript is extremely long (>5000 words):
- Focus on action items and decisions first
- Summarize discussion sections more heavily
- Offer to extract specific sections if user requests

### Missing Context
If key information is missing:
- Note what's missing in the output (e.g., "Date not specified")
- Make reasonable assumptions and note them
- Suggest asking attendees for clarification if critical

## Output Format

The processed meeting notes should be:
- ✅ Clear and scannable
- 📋 Action items formatted as checkboxes
- 👤 Owners clearly identified
- 📅 Deadlines and timeframes noted
- 🔗 Links to related resources included
- 🎯 Decisions with rationale documented
- 📌 Easy to copy into weekly plans

## Tools to Use

- **Read**: Read meeting transcript file or notes template
- **Write**: Create structured meeting notes document
- **Bash**: Execute scripts for owner inference, date parsing

## Best Practices

- Preserve original context and nuance
- Don't invent information not in the transcript
- When uncertain about ownership, mark as "[To be assigned]"
- Include enough context so action items make sense later
- Link related action items together
- Flag urgent or time-sensitive items prominently
- Use consistent formatting for easy parsing by other tools

## Related Skills

- **new-week**: Add extracted action items to weekly plan
- **track-actions**: Track action items across time
- **link-docs**: Create proper links to referenced documents

## Example Usage Patterns

1. **Post-Meeting Processing**
   ```
   user: "Here's the transcript from today's architecture meeting: [paste transcript]"
   skill: Processes transcript, extracts 8 action items, 3 decisions, generates structured notes
   ```

2. **Batch Processing**
   ```
   user: "Process all meeting notes from this week"
   skill: Reads multiple transcripts, generates structured docs for each
   ```

3. **Action Item Extraction Only**
   ```
   user: "Just extract the action items from this meeting"
   skill: Focuses on action items, provides quick list with owners
   ```

4. **Integration with Weekly Planning**
   ```
   user: "Process this meeting and add action items to this week's plan"
   skill: Extracts items and suggests placement in weekly plan
   ```

## Example Output

```markdown
---
title: Skills Journey Architecture Review
date: 2026-02-09
week: 2026-02-09
type: work-note
links:
  weekly: ../Weekly Plan/2026-02-09/README.md
---

# Skills Journey Architecture Review
**Date:** February 9, 2026
**Attendees:** Alex Chen, Avery, Jordan Patel, Taylor, Casey Park
**Context:** Review of Skills Journey project architecture and team ownership clarification

## Goals
- Define team ownership boundaries for Skills Journey components
- Clarify responsibilities between engineering and data science teams
- Identify integration points with UB Admin Agent

## Decisions
- **Decision**: Data science team will own skill library development, engineering team will own learner-facing features
  - **Rationale**: Aligns with core competencies and existing ownership patterns
  - **Alternatives**: Single team ownership (rejected due to skill gaps), shared ownership (too complex)
  - **Impact**: Clear boundaries enable parallel work streams
  - **Decided by**: Alex, Avery, Taylor

- **Decision**: Postpone GraphQL layer until client needs are clearer
  - **Rationale**: Avoid premature optimization, iterate based on actual usage
  - **Alternatives**: Build GraphQL now (rejected as speculative)
  - **Impact**: Reduces Q1 scope, enables faster skill library delivery

## Action Items
- [ ] **Alex**: Work with relevant leadership to define and clarify team ownership for each major component
    - Deadline: Next week
    - Context: Create architecture diagram with team boundaries
    - Link: Related to Skills Journey roadmap
- [ ] **Avery**: Share skill library and roadmap documents with the group
    - Deadline: This week
    - Context: Enable team review and feedback
- [ ] **Avery**: Continue working with Jamie and Ahmad's team to productionize skill library
    - Deadline: Q1
    - Context: Define data models and service needs
- [ ] **Alex**: Catch up with Taylor and others to get feedback on architecture
    - Deadline: Next week
    - Context: Validate ownership boundaries and approach

## Next Steps
- Follow-up meeting with Anisha, Jordan, Austin, Taylor to clarify contracts between teams (Week of Feb 16)
- Architecture diagram creation and review (Feb 11-13)
- Begin milestone 5 work on skill library productionalization (Q1)

## Notes

### Architecture Overview
- Skills Journey involves conversational AI agent for org admins to define learning goals
- Skill library provides structured skill hierarchy using AI analysis
- Integration with learner profile and learning path generation planned for Q2

### Open Questions
- GraphQL layer timing and scope
- Relationship between new skills library and existing taxonomy
- Performance considerations for Skills Guidance Service at scale

### Key Insights
- Current version uses SageMaker with results in Databricks
- Milestone 1 complete, Milestone 5 will focus on productionization
- Taxonomy integration possible but not current priority
```

## Integration Notes

This skill works best when:
- Meeting transcripts have clear speaker attribution
- Action items use explicit language ("will", "should", "need to")
- Decisions are stated with rationale
- Attendee names and roles are clear
- Used in conjunction with new-week skill for seamless workflow
