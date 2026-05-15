# Hub Document Structure Reference

## Overview

The hub directory contains strategic technical documentation for the Learning Systems organization at Udemy. These documents serve as the primary reference for major features, organizational structure, and processes.

**Hub Location:** `{hub}/`

## Hub Documents Index

### 1. LearningPath.md (62KB)
**Type:** Technical Onboarding Guide
**Purpose:** Comprehensive documentation for the learning paths feature
**Audience:** Engineers, Product Managers, Data Scientists

**Key Sections:**
- API Reference (REST and GraphQL endpoints)
- Data Models (LearningPath, LearningPathItem, UserLearningPath)
- Architecture Patterns (service boundaries, ownership)
- Common Debugging Scenarios
- Frontend and Backend Integration Points

**Update Frequency:** Quarterly or when major changes occur
**Owners:** Learning Paths team, CTE pod

**Typical Content:**
- Technical specifications
- API documentation
- Database schemas
- Code examples
- Troubleshooting guides

---

### 2. OrganizationAssignments.md (68KB)
**Type:** Technical Onboarding Guide
**Purpose:** Documentation for organization assignments feature
**Audience:** Engineers, Product Managers

**Key Sections:**
- Organization Assignment Workflows
- Admin Capabilities and Permissions
- API Integration Patterns
- Data Synchronization
- Team Ownership Boundaries

**Update Frequency:** Quarterly or when org structure changes
**Owners:** Organization features team

**Typical Content:**
- Feature architecture
- Permission models
- Integration points
- Admin workflows
- Team responsibilities

---

### 3. labs_vocareum.md (43KB)
**Type:** Technical & Operational Documentation
**Purpose:** Labs and Vocareum integration guide
**Audience:** Engineers, SREs, Support

**Key Sections:**
- Vocareum Integration Architecture
- Lab Workspace Types and Limitations
- Security and Access Control
- Operational Runbooks
- Future Migration Plans

**Update Frequency:** Monthly or when operational changes occur
**Owners:** Technical Skills Mastery pod, Labs team

**Typical Content:**
- Infrastructure setup
- Vendor integration details
- Security considerations
- Troubleshooting runbooks
- Migration strategies

---

### 4. LS Eng Leads - Working Docs.md (6.5KB)
**Type:** Process & Meeting Documentation
**Purpose:** Living document for engineering leadership
**Audience:** Engineering leads, managers

**Key Sections:**
- Team Rituals and Meetings
- Decision-Making Frameworks
- Cross-Team Coordination
- Resource Allocation

**Update Frequency:** Weekly or bi-weekly
**Owners:** Engineering leadership (Alex, Jordan, Sam, Riley)

**Typical Content:**
- Meeting agendas
- Decision logs
- Action items
- Team processes
- Coordination notes

---

### 5. Hiring.md (10KB)
**Type:** Process Documentation
**Purpose:** Hiring processes and interview guides
**Audience:** Hiring managers, interviewers, recruiters

**Key Sections:**
- Interview Process and Rubrics
- Role Levels and Expectations
- Team Growth Planning
- Onboarding Workflows

**Update Frequency:** Quarterly or when hiring active
**Owners:** Engineering leadership, recruiting

**Typical Content:**
- Job descriptions
- Interview questions
- Evaluation rubrics
- Onboarding checklists
- Team capacity planning

---

## Document Metadata Standards

### Recommended Frontmatter (YAML)
```yaml
---
title: Document Title
type: technical-guide | process-doc | onboarding
last_updated: 2026-02-17
owners:
  - Team Name
  - Individual Name
audience:
  - Engineers
  - Product Managers
status: active | deprecated | in-progress
---
```

### Required Sections
1. **Title** (H1): Clear, descriptive title
2. **Overview/Summary**: 2-3 sentence overview
3. **Table of Contents**: For documents >1000 lines
4. **Main Content**: Organized with clear headings
5. **Related Resources**: Links to related docs

### Optional Sections
- **Change Log**: Recent updates
- **Contributors**: People who maintain this doc
- **Feedback**: How to provide feedback
- **External Links**: Related resources

---

## Freshness Indicators

Documents are evaluated for freshness based on last modified date:

- 🟢 **Fresh (0-30 days)**: Recently updated, likely current
- 🟡 **Active (31-90 days)**: Moderate age, probably still relevant
- 🟠 **Aging (91-180 days)**: Getting old, may need review
- 🔴 **Stale (180+ days)**: Very old, likely outdated

**Action Thresholds:**
- Hub documents should be reviewed at least quarterly (every 90 days)
- If document reaches 🔴 Stale status, trigger review
- Major changes to systems should trigger documentation update

---

## Document Categories

### Technical Guides
Purpose: Deep technical documentation for features
Examples: LearningPath.md, OrganizationAssignments.md
Update Frequency: Quarterly or on major changes
Depth: Very detailed, includes code examples

### Operational Runbooks
Purpose: How to operate and troubleshoot systems
Examples: labs_vocareum.md
Update Frequency: Monthly or as operations change
Depth: Step-by-step procedures, troubleshooting

### Process Documentation
Purpose: Team processes and workflows
Examples: Hiring.md, LS Eng Leads docs
Update Frequency: Weekly to quarterly
Depth: Procedural, includes templates

### Onboarding Guides
Purpose: Help new team members get up to speed
Examples: All major feature docs
Update Frequency: Quarterly
Depth: Progressive detail, assumes little context

---

## Naming Conventions

### File Names
- Use descriptive names: `LearningPath.md` not `lp.md`
- PascalCase or snake_case: `LearningPath.md` or `learning_path.md`
- Avoid abbreviations unless widely known: `LS Eng Leads - Working Docs.md`

### Section Headings
- Use sentence case: "API reference" not "API Reference"
- Be descriptive: "Common debugging scenarios" not "Debugging"
- Use parallel structure in lists

### Links and References
- Use relative paths for internal docs: `../Weekly Plan/2026-02-16/README.md`
- Use full URLs for external resources
- Convert plain URLs to markdown links with titles

---

## Cross-References

### Common Link Patterns

**From Weekly Plans to Hub:**
```markdown
See [Learning Paths technical guide](../hub/LearningPath.md) for details
```

**From Hub Docs to Weekly Plans:**
```markdown
Recent work: [Weekly Plan Feb 16](../Weekly Plan/2026-02-16/README.md)
```

**From Hub Docs to Team Profiles:**
```markdown
Owner: [Jordan Patel](../teammembers/Jordan Patel/README.md)
```

### Backlinks
Hub documents should maintain "Referenced By" sections:
```markdown
## Referenced By
- [Weekly Plan Feb 9](../Weekly Plan/2026-02-09/README.md) - Labs migration planning
- [Meeting Notes: Labs Strategy](../meeting-notes/2026-01-15-labs.md) - Architecture discussion
```

---

## Document Ownership

### Responsibilities
- **Content Owner**: Ensures accuracy and completeness
- **Technical Owner**: Subject matter expert
- **Update Owner**: Ensures regular reviews

### Ownership Model
```markdown
## Document Ownership

**Content Owner:** Jordan Patel (Skills Enablement lead)
**Technical Owner:** Taylor (Data Science)
**Last Reviewed:** 2026-02-15
**Next Review:** 2026-05-15 (quarterly)
```

---

## Maintenance Schedule

### Daily
- No action required for hub docs

### Weekly
- Update "LS Eng Leads - Working Docs.md" with meeting notes

### Monthly
- Review operational docs (labs_vocareum.md)
- Check for broken links
- Update based on major changes

### Quarterly
- Review all technical guides
- Update architecture diagrams
- Refresh examples and code snippets
- Archive deprecated content

### Annually
- Major overhaul if needed
- Reorganize structure
- Consolidate redundant content

---

## Integration with Other Documentation

### Weekly Plans
Weekly plans reference hub docs for context:
- Link to relevant hub doc when working on features
- Note updates made to hub docs

### Meeting Notes
Meeting notes should link to hub docs:
- Reference existing documentation
- Note decisions that affect hub docs
- Create action items to update docs

### Team Profiles
Team member profiles link to hub docs they own:
- Show ownership and expertise
- Track contributions to documentation

### Jira/GitHub
Technical issues reference hub docs:
- Link to architecture documentation
- Reference troubleshooting guides

---

## Search and Discovery

### Keywords by Document

**LearningPath.md:**
- learning paths, learning path items, user learning path
- GraphQL, API, data models
- architecture, service boundaries
- frontend, backend, integration

**OrganizationAssignments.md:**
- organization, assignments, admin
- permissions, workflows, coordination
- teams, groups, org structure

**labs_vocareum.md:**
- labs, vocareum, strigo
- workspaces, environments, infrastructure
- security, access control, runbooks
- migration, vendor, integration

**LS Eng Leads - Working Docs.md:**
- engineering leads, leadership, management
- meetings, rituals, decisions
- coordination, alignment, planning

**Hiring.md:**
- hiring, recruiting, interviews
- levels, roles, expectations
- onboarding, growth, capacity

### Search Commands

Find documents by keyword:
```bash
grep -l "keyword" {hub}/*.md
```

Find documents by size:
```bash
find {hub}/ -name "*.md" -size +50k
```

Find recently updated documents:
```bash
find {hub}/ -name "*.md" -mtime -30
```

---

## Quality Checklist

Before publishing or updating a hub document:

- [ ] Title is clear and descriptive
- [ ] Overview/summary is present
- [ ] Table of contents for long docs (>1000 lines)
- [ ] All sections have clear headings
- [ ] Code examples are current and tested
- [ ] Links are not broken
- [ ] Ownership is documented
- [ ] Last updated date is accurate
- [ ] Related resources are linked
- [ ] Formatting is consistent

---

## Related Skills

- **docs-hub**: Navigate and search hub documents
- **link-docs**: Create proper markdown links
- **doc-health**: Audit documentation quality

---

## Example Hub Document Template

```markdown
---
title: Feature Name Technical Guide
type: technical-guide
last_updated: 2026-02-17
owners:
  - Team Name
  - Lead Engineer Name
audience:
  - Engineers
  - Product Managers
status: active
---

# Feature Name Technical Guide

**Last Updated:** February 17, 2026
**Owners:** Team Name, Lead Engineer

## Overview

{2-3 sentence overview of the feature}

## Table of Contents

- [Architecture](#architecture)
- [API Reference](#api-reference)
- [Data Models](#data-models)
- [Common Workflows](#common-workflows)
- [Troubleshooting](#troubleshooting)
- [Related Resources](#related-resources)

## Architecture

{Architecture overview, diagrams, service boundaries}

## API Reference

{REST and GraphQL endpoints, parameters, responses}

## Data Models

{Database schemas, entity relationships}

## Common Workflows

{Step-by-step guides for common tasks}

## Troubleshooting

{Common issues and solutions}

## Related Resources

- [Related Hub Doc](./RelatedDoc.md)
- [External Resource](https://example.com)

## Referenced By

- [Weekly Plan](../Weekly Plan/2026-02-16/README.md)
- [Meeting Notes](../meeting-notes/2026-02-10.md)

## Change Log

**2026-02-17**: Updated API reference with new endpoints
**2026-01-15**: Added troubleshooting section
**2025-12-10**: Initial version
```
