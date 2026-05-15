# URL Patterns Reference

## Regex Patterns for Service Detection

### Jira (Udemy Atlassian)
```regex
# Ticket URL
https://udemy\.atlassian\.net/browse/([A-Z]+-\d+)

# Capture groups:
# $1 = Ticket ID (e.g., SE-1234, LS-668)
```

**Examples:**
- `https://udemy.atlassian.net/browse/SE-1234`
- `https://udemy.atlassian.net/browse/LS-668`
- `https://udemy.atlassian.net/browse/ESR-1987`

**Link Format:**
```markdown
[SE-1234: Add new feature to labs](https://udemy.atlassian.net/browse/SE-1234)
```

### GitHub (Pull Requests)
```regex
# PR URL
https://github\.com/([^/]+)/([^/]+)/pull/(\d+)

# Capture groups:
# $1 = Organization (e.g., udemy)
# $2 = Repository (e.g., coding-labs)
# $3 = PR number (e.g., 123)
```

**Examples:**
- `https://github.com/udemy/coding-labs/pull/1196`
- `https://github.com/udemy/frontends-learner-experience/pull/710`

**Link Format:**
```markdown
[PR #123: Implement new feature](https://github.com/udemy/coding-labs/pull/123)
```

### GitHub (Issues)
```regex
# Issue URL
https://github\.com/([^/]+)/([^/]+)/issues/(\d+)

# Capture groups:
# $1 = Organization
# $2 = Repository
# $3 = Issue number
```

**Examples:**
- `https://github.com/udemy/coding-labs/issues/42`

**Link Format:**
```markdown
[Issue #42: Bug in workspace loader](https://github.com/udemy/coding-labs/issues/42)
```

### Google Docs (Documents)
```regex
# Document URL
https://docs\.google\.com/document/d/([a-zA-Z0-9_-]+)

# Capture groups:
# $1 = Document ID
```

**Examples:**
- `https://docs.google.com/document/d/1uROGfrxztBJBRF2mnrwn7yDHfUZT_IiVRjO3VNF7mYo/edit`
- `https://docs.google.com/document/d/1M7OViQbyYG2fC8hLKSZWE0XERECuDX5WCk-hISyrHZ0/edit?tab=t.0`

**Link Format:**
```markdown
[Labs 2026 Proposal](https://docs.google.com/document/d/1uROGfrxztBJBRF2mnrwn7yDHfUZT_IiVRjO3VNF7mYo/edit)
```

**Note:** Google Docs API requires OAuth. Fall back to generic title or manual entry.

### Google Docs (Presentations)
```regex
# Presentation URL
https://docs\.google\.com/presentation/d/([a-zA-Z0-9_-]+)

# Capture groups:
# $1 = Presentation ID
```

**Examples:**
- `https://docs.google.com/presentation/d/133AcklbdZDGpiTu3nabjW9R4RgisJ-tk20x_89o-9kY/edit`

**Link Format:**
```markdown
[Skills Journey Slides](https://docs.google.com/presentation/d/133AcklbdZDGpiTu3nabjW9R4RgisJ-tk20x_89o-9kY/edit)
```

### Confluence (Udemy Atlassian Wiki)
```regex
# Page URL
https://udemy\.atlassian\.net/wiki/spaces/([^/]+)/pages/(\d+)

# Capture groups:
# $1 = Space key (e.g., PDEUX)
# $2 = Page ID
```

**Examples:**
- `https://udemy.atlassian.net/wiki/spaces/PDEUX/pages/610828354/Skills+Learning+Portfolio+Roadmap+and+OKRs`
- `https://udemy.atlassian.net/wiki/spaces/PDEUX/pages/693108767/Learner+Profile+MCP`

**Link Format:**
```markdown
[Skills & Learning Portfolio Roadmap](https://udemy.atlassian.net/wiki/spaces/PDEUX/pages/610828354)
```

### Slack Messages
```regex
# Message URL
https://udemy\.slack\.com/archives/([^/]+)/p(\d+)

# Capture groups:
# $1 = Channel ID (e.g., C0AACG78GBY)
# $2 = Message timestamp (e.g., 1770417852443129)
```

**Examples:**
- `https://udemy.slack.com/archives/C0AACG78GBY/p1770417852443129`
- `https://udemy.slack.com/archives/C09FLBV7B97/p1768931658984599`

**Link Format:**
```markdown
[#channel-name: Security PR discussion](https://udemy.slack.com/archives/C0AACG78GBY/p1770417852443129)
```

**Note:** Requires Slack API to fetch channel names and message previews.

### Twitter/X
```regex
# Tweet URL
https://x\.com/([^/]+)/status/(\d+)

# Capture groups:
# $1 = Username
# $2 = Tweet ID
```

**Examples:**
- `https://x.com/gdb/status/2019566641491963946?s=20`

**Link Format:**
```markdown
[Tweet from @gdb](https://x.com/gdb/status/2019566641491963946?s=20)
```

### Databricks
```regex
# Dashboard URL
https://udemy-datainfra\.cloud\.databricks\.com/dashboardsv3/([a-f0-9]+)

# Capture groups:
# $1 = Dashboard ID
```

**Examples:**
- `https://udemy-datainfra.cloud.databricks.com/dashboardsv3/01ef37bf26b6136193f8ac4ebb5123ef`

**Link Format:**
```markdown
[Databricks Dashboard: Latency](https://udemy-datainfra.cloud.databricks.com/dashboardsv3/01ef37bf26b6136193f8ac4ebb5123ef)
```

### Datadog
```regex
# Dashboard URL
https://app\.datadoghq\.com/dashboard/([^/]+)

# Capture groups:
# $1 = Dashboard ID
```

**Examples:**
- `https://app.datadoghq.com/dashboard/tkp-4bm-gzw/ai-assistant-experience-dashboard`

**Link Format:**
```markdown
[Datadog: AI Assistant Experience](https://app.datadoghq.com/dashboard/tkp-4bm-gzw/ai-assistant-experience-dashboard)
```

## API Endpoints

### Jira API
```bash
# Get ticket details
GET https://udemy.atlassian.net/rest/api/3/issue/{TICKET_ID}
Authorization: Bearer ${JIRA_TOKEN}

# Response includes:
# - fields.summary (ticket title)
# - fields.description (ticket description)
# - fields.status (ticket status)
```

### GitHub API
```bash
# Get PR details
GET https://api.github.com/repos/{owner}/{repo}/pulls/{number}
Authorization: token ${GITHUB_TOKEN}

# Get Issue details
GET https://api.github.com/repos/{owner}/{repo}/issues/{number}
Authorization: token ${GITHUB_TOKEN}

# Response includes:
# - title (PR/Issue title)
# - state (open, closed, merged)
# - user.login (author)
```

### GitHub CLI (Preferred)
```bash
# Get PR title
gh pr view {number} --repo {owner}/{repo} --json title -q .title

# Get Issue title
gh issue view {number} --repo {owner}/{repo} --json title -q .title

# Advantages:
# - Uses existing gh auth
# - Simpler syntax
# - Better error handling
```

### Confluence API
```bash
# Get page details
GET https://udemy.atlassian.net/wiki/rest/api/content/{PAGE_ID}
Authorization: Bearer ${CONFLUENCE_TOKEN}

# Response includes:
# - title (page title)
# - _links.webui (relative URL)
# - version.number (version)
```

### Slack API
```bash
# Get channel info (requires Slack app or token)
GET https://slack.com/api/conversations.info?channel={CHANNEL_ID}
Authorization: Bearer ${SLACK_TOKEN}

# Get message (requires additional permissions)
GET https://slack.com/api/conversations.history
```

## Fallback Strategies

### When API Not Available
1. **HTML Title Extraction**
   ```bash
   curl -sL "$URL" | grep -oP '(?<=<title>).*?(?=</title>)' | head -1
   ```

2. **Generic Format**
   - Jira: `[Jira Ticket SE-1234](URL)`
   - GitHub: `[GitHub PR #123](URL)`
   - Google Docs: `[Google Doc](URL)`

3. **Manual Title**
   - Leave placeholder: `[TODO: Add title](URL)`
   - User can fill in manually

### When Rate Limited
1. **Cache Results**
   - Store fetched titles in temporary file
   - Reuse for subsequent requests

2. **Batch Processing**
   - Process URLs in groups
   - Add delays between batches

3. **Partial Results**
   - Return what was successfully fetched
   - Note remaining URLs to process later

## Short-form References

### Jira Ticket IDs
```regex
# Match standalone ticket IDs
\b([A-Z]+-\d+)\b

# Convert to full URL
SE-1234 → https://udemy.atlassian.net/browse/SE-1234
```

### GitHub References
```regex
# Match PR/Issue references in text
#(\d+)

# Requires repo context to build full URL
#123 → https://github.com/{repo}/pull/123
```

## Link Text Conventions

### Jira Tickets
- Include ticket ID and summary: `[SE-1234: Feature title](URL)`
- Keep summary concise (< 60 chars)

### GitHub PRs/Issues
- Include PR/Issue number: `[PR #123: Title](URL)` or `[Issue #42: Title](URL)`
- Indicate status if relevant: `[PR #123: Title](URL) (Merged)`

### Documents
- Use document title: `[Document Title](URL)`
- Add type if helpful: `[Proposal: Labs 2026](URL)`

### Slack Messages
- Include channel and context: `[#channel: Topic](URL)`
- Keep context brief

## Testing Patterns

### Valid URLs to Test
```
# Jira
https://udemy.atlassian.net/browse/SE-1234
https://udemy.atlassian.net/browse/LS-668

# GitHub
https://github.com/udemy/coding-labs/pull/123
https://github.com/udemy/repo/issues/42

# Google Docs
https://docs.google.com/document/d/abc123/edit

# Confluence
https://udemy.atlassian.net/wiki/spaces/PDEUX/pages/12345

# Slack
https://udemy.slack.com/archives/C123/p1234567890
```

### Edge Cases
```
# URL with query parameters
https://udemy.atlassian.net/browse/SE-1234?focusedCommentId=1372284

# URL with anchor
https://docs.google.com/document/d/abc123/edit#heading=h.abc

# Short GitHub URL
https://github.com/udemy/repo/pull/123/files

# Malformed URL
https://udemy.atlassian.net/browse/SE- (missing number)
```
