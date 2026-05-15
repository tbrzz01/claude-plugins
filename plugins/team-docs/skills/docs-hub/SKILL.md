---
name: docs-hub
description: |
  Quick access and navigation for strategic hub documents with summaries and search. Use this skill when the user asks to "show hub docs", "navigate strategic docs", "find documentation", "what's in the hub", "search hub documents", or wants quick access to important technical documentation.

  This skill provides a dashboard view of key documentation with summaries, last updated dates, and quick access commands.

  <example>
  Context: User wants to find documentation about learning paths
  user: "What documentation do we have about learning paths?"
  assistant: "I'll search the hub documents for learning paths information."
  <commentary>
  The skill will scan hub documents, find relevant content, and provide quick access with summaries.
  </commentary>
  </example>
version: 1.0.0
---

# Docs Hub Skill

## Description
Provides quick access and navigation to strategic hub documents with automatic summaries, keyword search, and staleness indicators. Acts as a documentation dashboard for key technical and strategic documents.

## Input
- No parameters required (shows all hub docs)
- Optional: Search query (keyword or topic)
- Optional: Document type filter (technical, onboarding, strategic, etc.)

## Instructions

### Phase 1: Index Hub Documents

1. **Locate Hub Directory**
   - Path: `/Users/trey.briggs/Code/documentation/work/udemy/hub/`
   - Scan for all markdown files in this directory
   - Track file metadata (size, modified date)

2. **Identify Key Documents**
   Key strategic documents to index:
   - `LearningPath.md` - Learning paths technical guide
   - `OrganizationAssignments.md` - Org assignments onboarding
   - `labs_vocareum.md` - Labs and Vocareum documentation
   - `LS Eng Leads - Working Docs.md` - Engineering leads docs
   - `Hiring.md` - Hiring documentation
   - Any other `.md` files in the hub directory

3. **Extract Metadata**
   For each document, capture:
   ```bash
   # File size
   ls -lh file.md | awk '{print $5}'

   # Last modified date
   stat -f "%Sm" -t "%Y-%m-%d" file.md  # macOS
   # or
   stat -c "%y" file.md | cut -d' ' -f1  # Linux

   # Line count
   wc -l < file.md
   ```

### Phase 2: Generate Document Summaries

1. **Extract Document Title**
   - Look for first H1 heading: `# Title`
   - Or use filename if no H1 found

2. **Generate Summary**
   Methods to create summary:

   **Option A: First paragraph**
   ```bash
   # Extract first non-empty paragraph after title
   sed -n '/^# /,/^$/p' file.md | grep -v '^#' | head -5
   ```

   **Option B: Table of Contents**
   ```bash
   # Extract all H2 headings as topics
   grep '^## ' file.md | sed 's/^## //'
   ```

   **Option C: Auto-generate**
   - Read first 500 words
   - Identify main topics (H2/H3 headings)
   - Note document type (guide, reference, onboarding)

3. **Identify Topics**
   Extract key topics from document:
   - Scan headings (## and ###)
   - Extract code blocks (language identifiers)
   - Note mentioned systems/services
   - Identify related projects

### Phase 3: Calculate Staleness

1. **Get Last Modified Date**
   ```bash
   MODIFIED=$(stat -f "%Sm" -t "%Y-%m-%d" file.md)
   ```

2. **Calculate Age**
   ```bash
   # Days since last modified
   MODIFIED_EPOCH=$(date -j -f "%Y-%m-%d" "$MODIFIED" "+%s")
   TODAY_EPOCH=$(date "+%s")
   DAYS_OLD=$(( ($TODAY_EPOCH - $MODIFIED_EPOCH) / 86400 ))
   ```

3. **Assign Freshness Indicator**
   - 🟢 Fresh (0-30 days): Recently updated
   - 🟡 Active (31-90 days): Moderate age
   - 🟠 Aging (91-180 days): Getting old
   - 🔴 Stale (180+ days): Likely outdated

### Phase 4: Create Hub Dashboard

1. **Generate Header**
   ```markdown
   # Documentation Hub
   **Last Updated:** {current_date}
   **Total Documents:** {count}

   ## Quick Access
   Use the Read tool to view any document listed below.
   ```

2. **List Strategic Documents**
   Format each document:
   ```markdown
   ### {Document Title} ({file_size})
   {Freshness} Last updated: {modified_date} ({days_ago} days ago)

   **Summary:** {1-2 sentence summary}

   **Key Topics:**
   - {Topic 1}
   - {Topic 2}
   - {Topic 3}

   **Quick Access:** `/Users/trey.briggs/Code/documentation/work/udemy/hub/{filename}`

   **Read command:**
   ```
   Read file: /Users/trey.briggs/Code/documentation/work/udemy/hub/{filename}
   ```
   ```

3. **Group by Category**
   Organize documents by type:
   - **Technical Guides**: LearningPath.md, labs_vocareum.md
   - **Onboarding**: OrganizationAssignments.md
   - **Process**: Hiring.md, Engineering leads docs
   - **Strategic**: Planning docs, Architecture docs

### Phase 5: Search Functionality

1. **Keyword Search**
   If user provides search query:
   ```bash
   # Search for keyword in all hub documents
   grep -l "keyword" /path/to/hub/*.md

   # Search with context
   grep -C 2 "keyword" /path/to/hub/*.md
   ```

2. **Topic Search**
   Map common queries to documents:
   - "learning paths" → LearningPath.md
   - "labs" → labs_vocareum.md
   - "org structure" → OrganizationAssignments.md
   - "hiring" → Hiring.md

3. **Full-text Search Results**
   For each matching document:
   ```markdown
   ### {Document Title}
   **Matches:** {count} occurrences of "{query}"

   **Context:**
   ```
   {snippet with keyword highlighted}
   ```

   **Read full document:** `/path/to/file.md`
   ```

### Phase 6: Quick Actions

1. **Provide Direct Read Commands**
   For common requests:
   ```markdown
   ## Common Actions

   - **View Learning Paths guide:**
     ```
     Read: /Users/trey.briggs/Code/documentation/work/udemy/hub/LearningPath.md
     ```

   - **View Labs documentation:**
     ```
     Read: /Users/trey.briggs/Code/documentation/work/udemy/hub/labs_vocareum.md
     ```
   ```

2. **Suggest Related Documents**
   Based on user query, suggest:
   ```markdown
   ## You Might Also Need
   - [Related Document 1](path) - {Brief description}
   - [Related Document 2](path) - {Brief description}
   ```

3. **Flag Stale Documents**
   Highlight documents needing attention:
   ```markdown
   ## ⚠️ Documents Needing Update (180+ days old)
   - {Stale Document 1} - Last updated {date}
   - {Stale Document 2} - Last updated {date}
   ```

## Output Formats

### Dashboard View (Default)
Shows all hub documents with summaries and metadata.

### Search Results View
Shows documents matching search query with context snippets.

### Single Document View
Shows detailed information about one document:
```markdown
# {Document Title}

**Path:** `/full/path/to/document.md`
**Size:** {file_size}
**Last Updated:** {date} ({days_ago} days ago)
**Freshness:** {indicator}

## Summary
{2-3 sentence summary}

## Table of Contents
{List of main sections}

## Key Topics
- {Topic 1}
- {Topic 2}
- {Topic 3}

## Quick Read
```
Read: /full/path/to/document.md
```

## Related Documents
- {Related doc 1}
- {Related doc 2}
```

## Example Output

### Dashboard View

```markdown
# Documentation Hub
**Last Updated:** February 17, 2026
**Total Documents:** 5 strategic documents

## Strategic Documents

### LearningPath.md (62KB)
🟡 Last updated: Dec 18, 2025 (61 days ago)

**Summary:** Comprehensive technical onboarding guide for the learning paths feature, including API reference, data models, architecture patterns, and debugging workflows.

**Key Topics:**
- API endpoints and GraphQL queries
- Data model relationships (LearningPath, LearningPathItem, UserLearningPath)
- Architecture and service boundaries
- Common debugging scenarios
- Frontend and backend integration points

**Quick Access:** `/Users/trey.briggs/Code/documentation/work/udemy/hub/LearningPath.md`

---

### OrganizationAssignments.md (68KB)
🟠 Last updated: Oct 15, 2025 (125 days ago)

**Summary:** Technical onboarding guide for organization assignments feature, covering architecture, API patterns, and team ownership.

**Key Topics:**
- Organization assignment workflows
- Admin capabilities and permissions
- API integration patterns
- Data synchronization
- Team ownership boundaries

**Quick Access:** `/Users/trey.briggs/Code/documentation/work/udemy/hub/OrganizationAssignments.md`

---

### labs_vocareum.md (43KB)
🟢 Last updated: Feb 10, 2026 (7 days ago)

**Summary:** Labs and Vocareum integration documentation including infrastructure, security considerations, and operational guides.

**Key Topics:**
- Vocareum integration architecture
- Lab workspace types and limitations
- Security and access control
- Operational runbooks
- Future migration plans

**Quick Access:** `/Users/trey.briggs/Code/documentation/work/udemy/hub/labs_vocareum.md`

---

### LS Eng Leads - Working Docs.md (6.5KB)
🟢 Last updated: Jan 28, 2026 (20 days ago)

**Summary:** Living document for Learning Systems engineering leads with team processes, meeting agendas, and decision logs.

**Key Topics:**
- Team rituals and meetings
- Decision-making frameworks
- Cross-team coordination
- Resource allocation

**Quick Access:** `/Users/trey.briggs/Code/documentation/work/udemy/hub/LS Eng Leads - Working Docs.md`

---

### Hiring.md (10KB)
🟡 Last updated: Nov 5, 2025 (104 days ago)

**Summary:** Hiring processes, interview guides, and role definitions for the Learning Systems team.

**Key Topics:**
- Interview process and rubrics
- Role levels and expectations
- Team growth planning
- Onboarding workflows

**Quick Access:** `/Users/trey.briggs/Code/documentation/work/udemy/hub/Hiring.md`

---

## ⚠️ Documents Needing Review (90+ days)
- **OrganizationAssignments.md** - 125 days old
- **Hiring.md** - 104 days old

Consider reviewing these documents for accuracy and relevance.

## Quick Commands

**View Learning Paths guide:**
```
Read: /Users/trey.briggs/Code/documentation/work/udemy/hub/LearningPath.md
```

**View Labs documentation:**
```
Read: /Users/trey.briggs/Code/documentation/work/udemy/hub/labs_vocareum.md
```

**Search hub documents:**
```
Use grep to search: grep -i "keyword" /Users/trey.briggs/Code/documentation/work/udemy/hub/*.md
```
```

### Search Results View

```markdown
# Search Results: "learning paths"

Found in **2 documents**:

---

## LearningPath.md
**Matches:** 47 occurrences

**Context snippets:**
```
Line 12: # Learning Paths Technical Guide
Line 45: Learning paths allow learners to follow curated sequences...
Line 123: The LearningPath model contains the following fields...
```

**Read full document:**
```
Read: /Users/trey.briggs/Code/documentation/work/udemy/hub/LearningPath.md
```

---

## OrganizationAssignments.md
**Matches:** 8 occurrences

**Context snippets:**
```
Line 234: Admins can assign learning paths to teams...
Line 567: Integration with learning paths requires coordination...
```

**Read full document:**
```
Read: /Users/trey.briggs/Code/documentation/work/udemy/hub/OrganizationAssignments.md
```
```

## Edge Cases

### Empty Hub Directory
If no documents found:
- Create placeholder hub structure
- Suggest initializing with key documents
- Offer to copy from examples

### Unreadable Files
If file cannot be read:
- Note the issue in dashboard
- Skip summary generation
- Flag for user attention

### Very Large Documents
If document > 100KB:
- Note the size in dashboard
- Suggest specific sections to read
- Offer to extract TOC only

### No Matching Search Results
If search returns nothing:
- Suggest alternative keywords
- List all available documents
- Offer to search in weekly plans or other docs

## Tools to Use

- **Read**: Read hub documents for summary generation
- **Glob**: Find all markdown files in hub directory
- **Grep**: Search for keywords across documents
- **Bash**: Get file metadata (size, modified date)

## Best Practices

- Keep summaries concise (1-2 sentences)
- Highlight documents needing updates
- Provide direct read commands for convenience
- Group related documents together
- Update hub index regularly (weekly or bi-weekly)
- Flag documents that might be obsolete

## Related Skills

- **link-docs**: Create links between hub docs and other documentation
- **process-meeting**: Meeting notes often reference hub documents
- **track-actions**: Action items may require reading hub docs

## Example Usage Patterns

1. **View All Docs**
   ```
   user: "Show me the docs hub"
   skill: Generates dashboard with all hub documents
   ```

2. **Search for Topic**
   ```
   user: "Find documentation about labs"
   skill: Searches hub, shows labs_vocareum.md with context
   ```

3. **Check Staleness**
   ```
   user: "Which hub documents need updating?"
   skill: Lists documents >90 days old
   ```

4. **Quick Access**
   ```
   user: "I need the learning paths guide"
   skill: Provides direct read command for LearningPath.md
   ```
