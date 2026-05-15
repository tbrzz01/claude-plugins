# Meeting Patterns Reference

## Common Meeting Structures

### Structure Type 1: Pre-formatted Notes (Most Common)
```markdown
#### Quick recap
[1-2 paragraph summary]

#### Next steps
- Person: Action item description
- Person: Another action item

#### Summary
##### Section Title
Detailed discussion points...
```

### Structure Type 2: Raw Transcript
```
Speaker 1: We need to address the labs error rate.
Speaker 2: I agree. Let's investigate this week.
Speaker 1: Can you take that on?
Speaker 2: Yes, I'll look into it.
```

### Structure Type 3: Hybrid (Structured with Raw Sections)
```markdown
### Meeting Title

**Attendees:** Person1, Person2, Person3

Discussion:
[Raw conversation or bullet points]

Action Items:
- TBD items that need parsing
```

## Action Item Patterns

### Explicit Ownership
- "Trey will create the document"
- "Jason: Review the PR"
- "Assigned to: Diby"
- "Owner: Charles"

### Implied Ownership (by verb subject)
- "Create a ticket for this" → Meeting organizer or context owner
- "We should schedule a meeting" → Person who raised the topic
- "Let's follow up with X" → Person suggesting the follow-up

### Implied Ownership (by domain)
- "Update the labs document" → Labs team lead
- "Review the architecture" → Architecture lead
- "Get PM feedback" → PM or person interfacing with PM

### Time-based Patterns
- "by EOD" → End of day
- "by EOD Monday" → Specific day
- "next week" → Within 7 days
- "Q1" → End of quarter
- "before the demo" → Before specific event

## Decision Patterns

### Explicit Decisions
- "We decided to use X"
- "The decision is to go with Y"
- "Agreed to proceed with Z"
- "We'll use approach A"

### Implicit Decisions
- "Let's go with X" (when followed by action items)
- "X makes more sense" (when no alternatives discussed further)
- "Sounds good" (when confirming a proposal)

### Decision Elements to Extract
1. **What** - The choice made
2. **Why** - Rationale or reasoning
3. **Alternatives** - Other options considered (if mentioned)
4. **Impact** - What this affects
5. **Reversibility** - Can this be changed easily? (if mentioned)

## Context Clues for Owner Inference

### By Name
- Direct mention: "Trey will do X"
- Indirect: "Let's have Trey handle Y"
- Question answered: "Can you do X?" "Yes" → Questioner assigns to responder

### By Role
- "PM should review" → Product Manager attendee
- "Engineering team to implement" → Engineering lead
- "Data science will analyze" → DS lead

### By Past Ownership
- If person owns the codebase/system being discussed
- If person has handled similar tasks before
- If person is the subject matter expert

### By Initiative
- Person who raised the topic
- Person who volunteered ("I can take that")
- Person who asked clarifying questions (shows engagement)

## Priority Indicators

### High Priority
- "urgent", "critical", "ASAP", "blocker"
- "needed for demo/launch/release"
- "before [imminent deadline]"
- Multiple follow-ups about the same item

### Medium Priority
- "soon", "this week", "next sprint"
- Part of regular workflow
- No specific urgency mentioned

### Low Priority
- "when we have time", "nice to have", "if possible"
- "low priority" explicitly stated
- "after [other work]"

## Meeting Types and Typical Outputs

### 1:1 Meetings
- Action items: Usually split between both attendees
- Decisions: Often career/project direction
- Format: Often more informal, conversational

### Team Meetings
- Action items: Distributed across team members
- Decisions: Team-wide processes or approaches
- Format: Status updates + planning

### Architecture Reviews
- Action items: Often related to documentation, design updates, POCs
- Decisions: Technical approach, technology choices
- Format: Deep technical discussion with diagrams

### Planning Meetings
- Action items: Project tasks, scheduling, resource allocation
- Decisions: Priorities, timelines, scope
- Format: Roadmap-focused, often with dates

### Incident Reviews
- Action items: Root cause investigation, prevention measures
- Decisions: Short-term fixes vs long-term solutions
- Format: Timeline-based, problem-focused

## Special Sections to Look For

### "Blockers" or "Risks"
- Extract as high-priority action items
- Note dependencies clearly
- Flag for immediate attention

### "Open Questions"
- Convert to action items for research/investigation
- Assign to domain experts
- Note that answer is needed before proceeding

### "Follow-up Topics"
- Suggest scheduling separate meetings
- Add to next week's agenda
- Track for future discussion

## Formatting Conventions

### Checkbox Style
```markdown
- [ ] Task description
    - Context: Why this matters
    - Owner: Who
    - Due: When
```

### Inline Owner Style
```markdown
- [ ] **Owner**: Task description (context) - Due: when
```

### Grouped by Owner Style
```markdown
### Trey Briggs
- [ ] Task 1
- [ ] Task 2

### Jason Diaz
- [ ] Task 3
```

## Link Patterns

### Jira Tickets
- `https://udemy.atlassian.net/browse/SE-1234`
- `SE-1234` (short form)

### Google Docs
- `https://docs.google.com/document/d/...`
- Often followed by "review this", "update this", "share this"

### GitHub PRs/Issues
- `https://github.com/udemy/repo/pull/123`
- `#123` (in repo context)

### Slack Messages
- `https://udemy.slack.com/archives/C.../p...`
- Often for context or follow-up threads

### Confluence Pages
- `https://udemy.atlassian.net/wiki/spaces/.../pages/...`
- Often for documentation or specs
