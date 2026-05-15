# GitHub API Reference for Team Activity

This document provides patterns for using GitHub CLI to fetch team member activity.

## GitHub CLI Authentication

### Check Auth Status
```bash
gh auth status
```

Output when authenticated:
```
✓ Logged in to github.com as username (keyring)
✓ Git operations for github.com configured to use ssh protocol.
✓ Token: *******************
```

### Login
```bash
gh auth login
```

## Fetching Pull Requests

### Search PRs by Author
```bash
gh search prs --author USERNAME --owner udemy --limit 50
```

### With JSON Output
```bash
gh search prs \
    --author bodureyupcan \
    --owner udemy \
    --created ">=2025-06-01" \
    --limit 50 \
    --json number,title,state,repository,closedAt,createdAt,mergedAt
```

### Response Format
```json
[
  {
    "number": 594,
    "title": "Add CredlyIssuanceRecord table",
    "state": "OPEN",
    "repository": {
      "name": "udemy/service-open-badge-issuance"
    },
    "createdAt": "2025-12-15T10:30:00Z",
    "closedAt": null,
    "mergedAt": null
  },
  {
    "number": 827,
    "title": "feat: update namespace",
    "state": "MERGED",
    "repository": {
      "name": "udemy/service-api-gateway"
    },
    "createdAt": "2025-12-17T08:00:00Z",
    "closedAt": "2025-12-17T08:40:00Z",
    "mergedAt": "2025-12-17T08:40:00Z"
  }
]
```

## Parsing PR Data

### Status Mapping
- `state == "OPEN"` → Status: "Open"
- `state == "MERGED"` → Status: "✅ Merged"
- `state == "CLOSED"` → Status: "❌ Closed"

### Cycle Time Calculation
```
cycle_time = closedAt - createdAt
```

Format options:
- Less than 1 hour: "30m"
- Less than 1 day: "3h 45m"
- 1+ days: "2d 5h"

### Date Formatting
```bash
# ISO to human-readable
2025-12-17T08:40:00Z → 2025-12-17
```

## Repository Information

### Extract Repo Name
Full name: `udemy/service-api-gateway`
Short name: `service-api-gateway` (remove "udemy/" prefix)

### Common Udemy Repos
- frontends-learner-experience
- website-django
- frontends-components-v2
- service-api-gateway
- service-open-badge-issuance
- service-mcp-chatgpt
- datainfra-sparkapps
- coding-labs

## Rate Limiting

### GitHub API Limits
- Authenticated: 5,000 requests/hour
- Search API: 30 requests/minute

### Check Rate Limit
```bash
gh api rate_limit
```

Response:
```json
{
  "resources": {
    "core": {
      "limit": 5000,
      "remaining": 4999,
      "reset": 1640000000
    },
    "search": {
      "limit": 30,
      "remaining": 29,
      "reset": 1640000060
    }
  }
}
```

### Handling Rate Limits
- If `remaining == 0`, wait until `reset` timestamp
- Implement exponential backoff
- Batch requests when possible
- Limit parallel execution to 5 concurrent

## Error Handling

### Common Errors

**Not Authenticated:**
```
gh: Not authenticated. Run: gh auth login
```

**User Not Found:**
```
No PRs found for author: invaliduser
```

**Network Error:**
```
Failed to fetch PRs: timeout
```

**Invalid JSON:**
```
Error parsing JSON response
```

### Retry Strategy
1. First failure: Retry immediately
2. Second failure: Wait 5 seconds, retry
3. Third failure: Wait 30 seconds, retry
4. Fourth failure: Skip user, log error, continue

## Filtering and Sorting

### Filter by Date Range
```bash
--created ">=2025-01-01"
--created "2025-01-01..2025-12-31"
```

### Filter by State
```bash
--state open
--state closed
--merged  # Only merged PRs
```

### Sort Results
```bash
--sort created
--sort updated
--order desc
```

### Limit Results
```bash
--limit 20   # Default
--limit 100  # Max per page
```

## Example Queries

### Last 6 Months of PRs
```bash
gh search prs \
    --author bodureyupcan \
    --owner udemy \
    --created ">=2025-06-01" \
    --json number,title,state,repository,closedAt,createdAt,mergedAt \
    --limit 50
```

### Only Merged PRs This Year
```bash
gh search prs \
    --author jasonmdiaz \
    --owner udemy \
    --created ">=2025-01-01" \
    --merged \
    --json number,title,repository,closedAt,createdAt,mergedAt \
    --limit 30
```

### PRs in Specific Repos
```bash
gh pr list \
    --author Alex-Hwang \
    --repo udemy/frontends-learner-experience \
    --state all \
    --limit 20 \
    --json number,title,state,closedAt,createdAt
```

## Performance Tips

1. **Use `--limit` appropriately**: Don't fetch more than needed
2. **Parallel execution**: Update multiple users concurrently (max 5)
3. **Cache results**: Store fetched data temporarily to avoid re-fetching
4. **Filter early**: Use date ranges to reduce data transfer
5. **Batch operations**: Group API calls when possible

## Data Validation

### Verify PR Data
- Check that `number` is a positive integer
- Validate `createdAt` is valid ISO timestamp
- Ensure `repository.name` starts with "udemy/"
- Handle null `closedAt` and `mergedAt` for open PRs

### Handle Missing Data
- If user has no PRs: Display "No recent PRs found"
- If repository name missing: Show as "Unknown Repo"
- If dates are invalid: Show "—" in table

## Markdown Table Generation

### Format
```markdown
| Repo | PR | Title | Status | Closed | Cycle Time |
|------|----|-------|--------|--------|------------|
| service-api-gateway | [#827](https://github.com/udemy/service-api-gateway/pull/827) | feat: update namespace | ✅ Merged | 2025-12-17 | 40m |
```

### Escaping
- Escape pipe characters in titles: `title.replace('|', '\\|')`
- Truncate very long titles: `title[:80] + '...'` if longer than 80 chars
- Handle special markdown characters

### Links
- Format: `[#{number}](https://github.com/udemy/{repo}/pull/{number})`
- Example: `[#827](https://github.com/udemy/service-api-gateway/pull/827)`
