# Action Item Extraction Patterns

This document defines patterns for identifying and parsing action items from weekly plans.

## Task Checkbox Patterns

### Open Tasks (to extract)
```
- [ ] Task description
```
- Must have space between brackets: `[ ]`
- May have leading whitespace/indentation

### Completed Tasks (to ignore)
```
- [x] Task description
- [X] Task description
```
- Has 'x' or 'X' between brackets
- Should NOT be included in tracking

## Category/Project Patterns

Tasks often start with a category in bold:

### Pattern Format
```
- [ ] **{Category}**: {Description}
```

### Common Categories
| Pattern | Category |
|---------|----------|
| `**Labs**:` | Labs |
| `**GwG**:` | Grow with Google |
| `**Review**:` | Reviews |
| `**Agentic AI**:` | Agentic AI |
| `**Skills Journey**:` | Skills Journey |
| `**CTE**:` | Course Taking Experience |
| `**Strategy**:` | Strategy |
| `**QBR**:` | Quarterly Business Review |
| `**Meeting**:` | Meetings |
| `**1:1**:` | One-on-ones |
| `**Team**:` | Team Management |
| `**Hiring**:` | Hiring/Recruitment |
| `**Documentation**:` | Documentation |

### Regex Pattern
```regex
^- \[ \] \*\*([^*]+)\*\*:\s*(.+)$
```
- Group 1: Category name
- Group 2: Task description

## Owner Identification Patterns

### Explicit Owner Mentions

#### In Task Description
```
- [ ] Jordan: Complete the feature
- [ ] **Labs**: Follow up with Riley on...
- [ ] Sam to review code
```

Patterns:
- `{Name}:` at start
- `with {Name}` in description
- `{Name} to {verb}` structure

#### Common Names to Match
From team roster:
- Alex (self)
- Jordan / Jordan Patel
- Sam / Sam Lee
- Riley / Riley / Riley Kim
- Casey / Casey Park
- Morgan / Morgan Eustace
- Manuel / Manuel Gutierrez
- Leonardo / Leo
- Iván / Ivan
- Carlos
- Ying / Ying Rao
- Jackson
- Alex / Alex Hwang
- Joao / Joao Cavalcanti
- Shanshan
- Maisa
- Linus
- Matthew
- William / Will
- Luke / Luke Smith
- Mei / Mei Wong

### Regex for Name Extraction
```regex
\b(Jordan|Sam|Riley|Casey|Morgan|Manuel|Leonardo|Ivan|Carlos|Ying|Jackson|Alex|Joao|Shanshan|Maisa|Linus|Matthew|William|Will|Luke|Mei)\b
```

### Implied Ownership
If no explicit owner:
- Tasks in daily sections (Monday, Tuesday, etc.) → Default to user (Alex)
- Tasks in "Carried Over" section → Check original context or default to user
- Tasks in "Notes-derived Action Items" → Look at meeting notes for context

## Priority Indicators

### Critical/Urgent Keywords
```
- [ ] **URGENT**: ...
- [ ] **CRITICAL**: ...
- [ ] ASAP: ...
- [ ] Blocker: ...
- [ ] Emergency: ...
```

Patterns to match:
```regex
(URGENT|CRITICAL|ASAP|blocker|emergency|urgent|critical)
```

### High Priority Indicators
```
- [ ] **High Priority**: ...
- [ ] Important: ...
- [ ] Due by {date}: ...
- [ ] Deadline: ...
```

Patterns:
```regex
(high priority|important|due by|deadline|must complete)
```

### Low Priority Indicators
```
- [ ] **Low Priority**: ...
- [ ] (low priority)
- [ ] When time permits: ...
- [ ] Nice to have: ...
```

Patterns:
```regex
(low priority|when time|nice to have|optional|backlog)
```

## Sub-task Patterns

Tasks may have indented sub-bullets:

```
- [ ] **Main Task**: Description
    - Sub-point 1
    - Sub-point 2
    - Note: Additional context
```

### Identification
- Indented with 4+ spaces or tab
- Follows a task line
- May start with `-` or other markers
- Include as context for the parent task

## Link Patterns

Tasks often contain links to resources:

### GitHub PR/Issue
```
https://github.com/udemy/repo/pull/123
https://github.com/udemy/repo/issues/456
```

### Jira Ticket
```
https://udemy.atlassian.net/browse/SE-1234
```

### Google Doc
```
https://docs.google.com/document/d/...
https://docs.google.com/presentation/d/...
```

### Slack Message
```
https://udemy.slack.com/archives/C.../p...
```

### Confluence Page
```
https://udemy.atlassian.net/wiki/spaces/...
```

## Age/History Patterns

### Carried Over Notes
```
- [ ] Task description
    - Carried over from {date}
    - Carried over from 1/20
    - Carried over from previous week
```

Patterns:
```regex
Carried over from ([A-Za-z]+ \d+, \d{4}|\d+/\d+|previous week|last week)
```

### Date Extraction
```regex
(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d{1,2}, \d{4}
\d{1,2}/\d{1,2}
```

## Context Section Patterns

Tasks appear in different sections:

### Daily Sections
```
### Monday (1/27)
- [ ] Task 1
- [ ] Task 2

### Tuesday (1/28)
- [ ] Task 3
```

Pattern:
```regex
^###\s+(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\s+\((\d+/\d+)\)
```

### Special Sections
- `## Working Tasks` - Active work this week
- `## Carried Over from Last Week` - Previously incomplete
- `## Notes-derived Action Items` - From meeting notes
- `## Tasks For Next Week` - Future planning

## Deduplication Patterns

### Same Task Across Weeks
Tasks may be identical or very similar:

```
Week 1: - [ ] **Labs**: Follow up on PR 1196
Week 2: - [ ] **Labs**: Follow up on PR 1196
```

Match criteria:
- Exact text match
- Same category + similar description (Levenshtein distance < 5)
- Same URL in task

### Handling Duplicates
- Count as single task
- Use earliest appearance for age
- Note frequency: "Appeared in 3 weeks"

## Example Task Parsing

### Input
```
- [ ] **Labs**: Follow through on work here - https://github.com/udemy/coding-labs/pull/1196
    - Carried over from 1/20
    - asked for clarification from Han
```

### Parsed Output
```yaml
checkbox: unchecked
category: Labs
description: Follow through on work here
url: https://github.com/udemy/coding-labs/pull/1196
sub_notes:
  - Carried over from 1/20
  - asked for clarification from Han
original_date: Jan 20, 2026
owner: Alex (implied, or inferred from "Han" context)
priority: medium (default, no indicators)
```

## Validation Rules

1. **Must have checkbox**: `- [ ]` or `- [x]`
2. **Checkbox format**: Exactly one space between brackets for open tasks
3. **Category optional**: Not all tasks have `**Category**:` format
4. **Owner optional**: Many tasks don't explicitly state owner
5. **Priority optional**: Most tasks don't have explicit priority
6. **Links optional**: Not all tasks have URLs

## Common False Positives

Avoid matching:
- List items that aren't tasks (no checkbox)
- Completed tasks `- [x]`
- Tasks in code blocks (```...```)
- Example/template tasks marked as such
