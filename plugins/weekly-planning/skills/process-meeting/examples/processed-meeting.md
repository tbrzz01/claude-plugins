# Example: Processed Meeting Output

This shows what the process-meeting skill outputs when given a meeting transcript.

---

## Input (Raw Transcript Excerpt)

```
### T&L Eng Leads - Bi-weekly

Trey: Let's start with updates on Skills Journey. Nishanth, can you share where we are?

Nishanth: We're making good progress on the skill library. The data pipeline is running in SageMaker with results in Databricks. We're in milestone 1 now, and milestone 5 will focus on productionizing the skill library.

Trey: Great. One question - do we need to build the GraphQL layer now, or can we wait?

Nishanth: I think we should postpone the GraphQL layer until the client's needs are better understood. Okan's team is aligned on this approach.

Trey: That makes sense. Let's hold off on that. What about team ownership? That's been a bit unclear.

Nishanth: Yes, we need to clarify that. The UB admin team will handle certain components while the Skills Journey team focuses on learner-facing features.

Trey: OK, I'll work with Martin, Ahmet, and John to define the team boundaries more clearly. Nishanth, can you share the skill library docs with the group?

Nishanth: Sure, I'll send those this week.

Trey: Perfect. Let's schedule a follow-up with Anisha, Jason, Austin, and Martin to clarify the contracts between teams. I'll also need to create an architecture diagram showing ownership boundaries.
```

---

## Output (Processed Meeting Notes)

```markdown
---
title: T&L Eng Leads - Bi-weekly (Skills Journey Discussion)
date: 2026-02-09
week: 2026-02-09
type: work-note
links:
  weekly: ../Weekly Plan/2026-02-09/README.md
---

# T&L Eng Leads - Bi-weekly (Skills Journey Discussion)
**Date:** February 9, 2026
**Attendees:** Trey Briggs, Nishanth, Okan (implied)
**Context:** Bi-weekly engineering leads sync focused on Skills Journey project status and team ownership clarification

## Goals
- Review Skills Journey skill library progress
- Clarify team ownership boundaries
- Determine timing for GraphQL layer implementation

## Decisions
- **Decision**: Postpone GraphQL layer until client needs are clearer
  - **Rationale**: Avoid premature optimization; iterate based on actual usage patterns
  - **Alternatives**: Build GraphQL now (rejected as speculative work)
  - **Impact**: Reduces Q1 scope, enables faster skill library delivery
  - **Decided by**: Nishanth, Trey (with Okan's team alignment)

- **Decision**: UB Admin team handles certain components, Skills Journey team focuses on learner-facing features
  - **Rationale**: Aligns with core competencies and existing ownership patterns
  - **Alternatives**: Single team ownership (rejected due to skill gaps)
  - **Impact**: Enables parallel work streams with clear boundaries
  - **Decided by**: Nishanth, Trey

## Action Items
- [ ] **Trey**: Work with Martin, Ahmet, and John to define team ownership boundaries more clearly
    - Deadline: Next week
    - Context: Create clarity for both teams on responsibilities
    - Related: Architecture diagram creation
- [ ] **Trey**: Create architecture diagram showing ownership boundaries
    - Deadline: Next week
    - Context: Visual representation for team alignment
    - Dependencies: Need team ownership definition first
- [ ] **Nishanth**: Share skill library documentation with the group
    - Deadline: This week
    - Context: Enable team review and feedback
- [ ] **Trey**: Schedule follow-up meeting with Anisha, Jason, Austin, and Martin
    - Deadline: Next week
    - Context: Clarify contracts between UB Admin Agent and Skills Journey teams
    - Purpose: Define interfaces and handoff points

## Next Steps
- Follow-up meeting scheduled for week of Feb 16
- Architecture diagram review (after creation)
- Begin milestone 5 work on skill library productionalization (Q1)

## Notes

### Skills Journey Status
- Data pipeline running in SageMaker with results stored in Databricks
- Currently in milestone 1
- Milestone 5 will focus on productionization
- Okan's team aligned on approach

### Key Technical Points
- GraphQL layer timing: Postponed until client needs clearer
- Team ownership: Split between UB Admin (certain components) and Skills Journey (learner-facing)
- Collaboration needed with Okan's team for productionization

### Open Questions
- Specific components each team will own (needs diagram)
- Interface contracts between teams (follow-up meeting needed)
- Timeline for milestone 5 work
```

---

## For Weekly Plan Integration

### Suggested Placement
Based on the action items, here's where they should go in this week's plan:

**Monday (Leadership & Planning)**
```markdown
- [ ] **Skills Journey Team Ownership**: Work with Martin, Ahmet, John to define boundaries
    - From meeting: T&L Eng Leads - Bi-weekly on Feb 9
    - Context: Create clarity for parallel workstreams
    - Related: Need to create architecture diagram
```

**Tuesday (Technical Deep Dive)**
```markdown
- [ ] **Skills Journey Architecture Diagram**: Create diagram showing team ownership boundaries
    - From meeting: T&L Eng Leads - Bi-weekly on Feb 9
    - Context: Visual representation for team alignment
```

**Wednesday (Coordination)**
```markdown
- [ ] **Schedule Skills Journey Follow-up**: Meeting with Anisha, Jason, Austin, Martin
    - From meeting: T&L Eng Leads - Bi-weekly on Feb 9
    - Context: Clarify contracts between UB Admin Agent and Skills Journey teams
```

---

## Summary Statistics

- **Meeting Type**: Bi-weekly Engineering Leads Sync
- **Duration**: ~15 minutes (estimate)
- **Key Outcomes**:
  1. GraphQL layer postponed (scope reduction)
  2. Team ownership approach clarified
  3. 4 action items created with clear owners
- **Action Items**: 4 total
  - Trey: 3 items
  - Nishanth: 1 item
- **Decisions**: 2 major decisions made
- **Follow-up Needed**: Yes - meeting to be scheduled for week of Feb 16

---

## Notes

This example demonstrates:
- Extraction of action items from conversational text
- Inference of owners from context
- Decision documentation with rationale
- Structured formatting for easy reference
- Integration suggestions for weekly planning
- Preservation of key technical details
