# Example: Linked Document

This is an example of a document that has been processed by the link-docs skill, showing how plain URLs are converted to rich markdown links with fetched titles.

## Before Processing

Here's what the document looked like before the link-docs skill processed it:

```markdown
# Weekly Plan Feb 16, 2026

## Tasks

### Labs Work
- Review the proposal: https://docs.google.com/document/d/1uROGfrxztBJBRF2mnrwn7yDHfUZT_IiVRjO3VNF7mYo/edit
- Check on ticket https://udemy.atlassian.net/browse/LS-668
- Review PR: https://github.com/udemy/coding-labs/pull/1196

### Architecture Discussion
- See the discussion: https://udemy.slack.com/archives/C0AACG78GBY/p1770417852443129
- Reference tweet: https://x.com/gdb/status/2019566641491963946
- Check board: https://udemy.atlassian.net/jira/software/c/projects/LS/boards/1551/backlog
```

## After Processing

After running the link-docs skill, all URLs have been converted to rich markdown links with descriptive titles:

```markdown
# Weekly Plan Feb 16, 2026

## Tasks

### Labs Work
- Review the proposal: [Labs 2026 Proposal](https://docs.google.com/document/d/1uROGfrxztBJBRF2mnrwn7yDHfUZT_IiVRjO3VNF7mYo/edit)
- Check on ticket [LS-668: Fix events being rejected](https://udemy.atlassian.net/browse/LS-668)
- Review PR: [PR #1196: Implement labs walkthrough feature](https://github.com/udemy/coding-labs/pull/1196)

### Architecture Discussion
- See the discussion: [Slack: #learning-systems - Data platform discussion](https://udemy.slack.com/archives/C0AACG78GBY/p1770417852443129)
- Reference tweet: [Tweet from @gdb on agent-first thinking](https://x.com/gdb/status/2019566641491963946)
- Check board: [Jira Board: LS Backlog](https://udemy.atlassian.net/jira/software/c/projects/LS/boards/1551/backlog)
```

## Detailed Examples by Service Type

### Jira Tickets

**Before:**
```
Fix the bug: https://udemy.atlassian.net/browse/SE-1234
```

**After:**
```
Fix the bug: [SE-1234: Add new feature to labs](https://udemy.atlassian.net/browse/SE-1234)
```

**Format:** `[{TICKET_ID}: {Title from Jira API}](URL)`

---

### GitHub Pull Requests

**Before:**
```
Review https://github.com/udemy/coding-labs/pull/1196
```

**After:**
```
Review [PR #1196: Implement labs walkthrough feature](https://github.com/udemy/coding-labs/pull/1196)
```

**Format:** `[PR #{number}: {Title from GitHub API}](URL)`

---

### GitHub Issues

**Before:**
```
Track this issue: https://github.com/udemy/coding-labs/issues/42
```

**After:**
```
Track this issue: [Issue #42: Bug in workspace loader](https://github.com/udemy/coding-labs/issues/42)
```

**Format:** `[Issue #{number}: {Title from GitHub API}](URL)`

---

### Google Docs

**Before:**
```
See proposal at https://docs.google.com/document/d/1uROGfrxztBJBRF2mnrwn7yDHfUZT_IiVRjO3VNF7mYo/edit
```

**After:**
```
See proposal at [Labs 2026 Proposal](https://docs.google.com/document/d/1uROGfrxztBJBRF2mnrwn7yDHfUZT_IiVRjO3VNF7mYo/edit)
```

**Format:** `[{Descriptive title from context or generic}](URL)`

**Note:** Google Docs requires OAuth, so title is inferred from context or left generic.

---

### Confluence Pages

**Before:**
```
Documentation: https://udemy.atlassian.net/wiki/spaces/PDEUX/pages/610828354
```

**After:**
```
Documentation: [Skills & Learning Portfolio Roadmap](https://udemy.atlassian.net/wiki/spaces/PDEUX/pages/610828354)
```

**Format:** `[{Page title from Confluence API}](URL)`

---

### Slack Messages

**Before:**
```
Check discussion: https://udemy.slack.com/archives/C0AACG78GBY/p1770417852443129
```

**After:**
```
Check discussion: [Slack: #learning-systems - Security PR discussion](https://udemy.slack.com/archives/C0AACG78GBY/p1770417852443129)
```

**Format:** `[Slack: #{channel-name} - {topic}](URL)`

---

### Twitter/X

**Before:**
```
Interesting thread: https://x.com/gdb/status/2019566641491963946
```

**After:**
```
Interesting thread: [Tweet from @gdb on agent-first thinking](https://x.com/gdb/status/2019566641491963946)
```

**Format:** `[Tweet from @{username} on {topic}](URL)`

---

### Datadog

**Before:**
```
Monitor: https://app.datadoghq.com/dashboard/tkp-4bm-gzw/ai-assistant-experience-dashboard
```

**After:**
```
Monitor: [Datadog: AI Assistant Experience Dashboard](https://app.datadoghq.com/dashboard/tkp-4bm-gzw/ai-assistant-experience-dashboard)
```

**Format:** `[Datadog: {Dashboard name from URL or context}](URL)`

---

### Databricks

**Before:**
```
Dashboard: https://udemy-datainfra.cloud.databricks.com/dashboardsv3/01ef37bf26b6136193f8ac4ebb5123ef
```

**After:**
```
Dashboard: [Databricks: Latency Metrics Dashboard](https://udemy-datainfra.cloud.databricks.com/dashboardsv3/01ef37bf26b6136193f8ac4ebb5123ef)
```

**Format:** `[Databricks: {Dashboard name from context}](URL)`

---

## Processing Summary Example

After processing a document, the skill generates a summary:

```markdown
## Link Processing Summary
- URLs found: 12
- Converted to markdown: 12
- Titles fetched: 10 (via API)
- Generic titles: 2 (API not available or authentication required)
- Related documents suggested: 5

### By Service Type
- Jira: 3 tickets (all titles fetched)
- GitHub: 2 PRs (all titles fetched)
- Google Docs: 2 docs (generic titles, OAuth not available)
- Slack: 2 messages (titles inferred from context)
- Twitter: 1 tweet (title inferred)
- Confluence: 1 page (title fetched)
- Datadog: 1 dashboard (title inferred)

### API Status
- ✅ GitHub CLI authenticated
- ❌ JIRA_TOKEN not set (used context-based titles)
- ❌ SLACK_TOKEN not set (used generic titles)
- ❌ CONFLUENCE_TOKEN not set (used context-based titles)
```

## Related Documents Section Example

The skill can also suggest related documents:

```markdown
## Related Documents

Based on content analysis, these documents may be related:

### Same Topic (Labs)
- [Labs 2026 Proposal](../hub/labs_vocareum.md) - Hub documentation
- [Weekly Plan Feb 9](../Weekly Plan/2026-02-09/README.md) - Previous week's Labs tasks
- [Labs Strategy Meeting](../meeting-notes/2026-01-15-labs-strategy.md) - Architecture discussion

### Same People (Trey, Diby, Evan)
- [1-on-1 with Diby](../meeting-notes/2026-02-12-diby-1on1.md) - Labs ownership discussion
- [Team Member: Dibyendu Tiwari](../teammembers/Dibyendu Tiwari/README.md) - Profile

### Same Timeframe (Feb 2026)
- [Skills Journey Architecture Review](../meeting-notes/2026-02-09-skills-journey.md)
- [Weekly Plan Feb 16](../Weekly Plan/2026-02-16/README.md)
```

## Backlinks Section Example

The skill can generate backlinks showing what documents reference this one:

```markdown
## Referenced By

This document is referenced in:

- [Weekly Plan Feb 16](../Weekly Plan/2026-02-16/README.md) - Action item: Review Labs proposal
- [1-on-1 with Evan - Feb 19](../meeting-notes/2026-02-19-evan-1on1.md) - GwG Wave 2 discussion
- [Team Member: Dibyendu Tiwari](../teammembers/Dibyendu Tiwari/README.md) - Current projects
```

## Best Practices Demonstrated

1. **Preserve Context**: Original text around URLs is maintained
2. **Descriptive Titles**: Link text includes ticket IDs, PR numbers, or meaningful descriptions
3. **Service Identification**: Clear indication of service type (Jira, PR, Slack, etc.)
4. **Consistent Format**: All links follow similar patterns for easy scanning
5. **Rich Context**: Titles provide enough information to understand the link without clicking

## Notes

- When API credentials are available, actual titles are fetched for better accuracy
- Without API access, the skill uses context-based or generic titles
- All original URLs are preserved—links are never broken
- The skill handles URLs in any context (bullet lists, paragraphs, tables)
