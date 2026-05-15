---
name: link-docs
description: |
  Auto-link related documents and create proper markdown links for external resources. Use this skill when the user asks to "link documents", "fix links", "connect related docs", "add backlinks", "format these URLs", or wants to create properly formatted markdown links with titles.

  This skill transforms plain URLs into rich markdown links with actual titles fetched from APIs, and helps maintain a web of related documentation.

  <example>
  Context: User has a document with many plain URLs
  user: "Can you convert all the URLs in this document to proper markdown links with titles?"
  assistant: "I'll fetch the titles for each URL and convert them to properly formatted markdown links."
  <commentary>
  The skill will identify all URLs, determine their type (Jira, GitHub, Google Docs, etc.), fetch actual titles using APIs, and format them as [Title](URL) markdown links.
  </commentary>
  </example>
version: 1.0.0
---

## Setup: Resolve Config Paths

Before any file operation, resolve `{placeholder}` references in this file:

1. Read `plugins/team-docs/config.local.json` (fall back to `config.example.json` if missing).
2. Substitute each `{placeholder}` with the matching key from the config. Top-level keys (e.g. `docs_root`, `vault_root`, `tech_docs_root`, `scripts_root`) and `subpaths` keys (e.g. `hub`, `teammembers`, `meeting_notes`, `myteam_index`) are valid.
3. Subpath values may themselves reference `{docs_root}` etc. — expand recursively.
4. Tilde (`~`) at the start of a path expands to `$HOME`.

If `config.local.json` is missing, tell the user to copy `config.example.json` to `config.local.json` and fill in their paths before continuing.


# Link Docs Skill

## Description
Automatically converts plain URLs to rich markdown links by fetching titles from various services (Jira, GitHub, Google Docs, Confluence, Slack). Also helps identify related documents and create bidirectional links.

## Input
- Document content (markdown file or text)
- Optional: Specific URL to format
- Optional: Service type (jira, github, confluence, etc.)

## Instructions

### Phase 1: Identify URLs and Service Types

1. **Scan for URLs**
   Use regex patterns to find URLs in the document:
   - Jira: `https://udemy.atlassian.net/browse/[A-Z]+-\d+`
   - GitHub PR: `https://github.com/[^/]+/[^/]+/pull/\d+`
   - GitHub Issue: `https://github.com/[^/]+/[^/]+/issues/\d+`
   - Google Docs: `https://docs.google.com/document/d/[^/]+`
   - Confluence: `https://udemy.atlassian.net/wiki/spaces/[^/]+/pages/\d+`
   - Slack: `https://udemy.slack.com/archives/[^/]+/p\d+`
   - Generic HTTP/HTTPS: `https?://[^\s]+`

2. **Classify Each URL**
   Determine the service type for each URL to use the appropriate API/method:
   - **Jira**: Ticket URLs
   - **GitHub**: PR or Issue URLs
   - **Google Docs**: Document or Presentation URLs
   - **Confluence**: Page URLs
   - **Slack**: Message URLs
   - **Generic**: Other URLs

3. **Check Current Format**
   Determine if URL is already formatted:
   - Plain URL: `https://example.com/page`
   - Markdown link: `[Title](https://example.com/page)`
   - Already formatted: Skip or update title if stale

### Phase 2: Fetch Titles from APIs

1. **Jira Tickets**
   ```bash
   # Use Jira API
   TICKET_ID="SE-1234"
   curl -s "https://udemy.atlassian.net/rest/api/3/issue/${TICKET_ID}" \
     -H "Authorization: Bearer ${JIRA_TOKEN}" \
     | jq -r '.fields.summary'

   # Format: [SE-1234: Title](URL)
   ```

2. **GitHub PRs and Issues**
   ```bash
   # Use GitHub CLI (preferred)
   gh pr view 123 --repo udemy/repo --json title -q .title

   # Or GitHub API
   curl -s "https://api.github.com/repos/udemy/repo/pulls/123" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     | jq -r '.title'

   # Format: [PR #123: Title](URL) or [Issue #123: Title](URL)
   ```

3. **Google Docs**
   ```bash
   # Google Docs API requires OAuth, which is complex
   # Alternative: Use generic title extraction from HTML
   # Or keep as: [Google Doc](URL) with manual title update

   # Format: [Doc Title](URL) or [Google Doc](URL) if title unavailable
   ```

4. **Confluence Pages**
   ```bash
   # Use Confluence API
   PAGE_ID="12345"
   curl -s "https://udemy.atlassian.net/wiki/rest/api/content/${PAGE_ID}" \
     -H "Authorization: Bearer ${CONFLUENCE_TOKEN}" \
     | jq -r '.title'

   # Format: [Page Title](URL)
   ```

5. **Slack Messages**
   ```bash
   # Slack API requires authentication and parsing
   # Simplified: Extract channel name from URL
   # Format: [#channel-name: message](URL)

   # Example: Extract channel ID from URL
   # https://udemy.slack.com/archives/C0AACG78GBY/p1770417852443129
   # Channel: C0AACG78GBY → look up channel name
   ```

6. **Generic URLs**
   ```bash
   # Fetch HTML title tag
   curl -sL "$URL" | grep -oP '(?<=<title>).*?(?=</title>)' | head -1

   # Format: [Page Title](URL)
   # Fallback: [URL](URL) if title extraction fails
   ```

### Phase 3: Format Markdown Links

1. **Standard Format**
   Convert URLs to markdown links:
   ```markdown
   Before: https://udemy.atlassian.net/browse/SE-1234
   After: [SE-1234: Add new feature to labs](https://udemy.atlassian.net/browse/SE-1234)
   ```

2. **Preserve Context**
   Keep surrounding text intact:
   ```markdown
   Before: Review ticket https://udemy.atlassian.net/browse/SE-1234 for details
   After: Review ticket [SE-1234: Add new feature to labs](https://udemy.atlassian.net/browse/SE-1234) for details
   ```

3. **Handle Multiple URLs**
   Process all URLs in document while preserving structure:
   ```markdown
   Before:
   - Ticket: https://udemy.atlassian.net/browse/SE-1234
   - PR: https://github.com/udemy/repo/pull/123

   After:
   - Ticket: [SE-1234: Add new feature](https://udemy.atlassian.net/browse/SE-1234)
   - PR: [PR #123: Implement feature](https://github.com/udemy/repo/pull/123)
   ```

### Phase 4: Create Related Document Links

1. **Identify Related Documents**
   Look for documents that might be related:
   - **Same topic**: Keywords match (labs, gwg, skills journey, etc.)
   - **Same people**: Mention same team members
   - **Same timeframe**: Created/modified in similar time period
   - **Explicit references**: One document mentions the other

2. **Scan Directory for Related Docs**
   ```bash
   # Find documents in the same directory or related directories
   # Example: Weekly plans might reference meeting notes
   ls "{weekly_plans}/"
   ls "{hub}/"
   ```

3. **Extract Keywords**
   From the current document, extract:
   - Project names: Skills Journey, Labs 2026, GwG
   - Team member names: Alex, Jordan, Sam, Riley
   - Technical terms: architecture, API, infrastructure

4. **Search for Related Documents**
   Use grep to find documents with similar keywords:
   ```bash
   grep -l "Skills Journey" /path/to/docs/**/*.md
   ```

5. **Suggest Links**
   Format suggestions for user:
   ```markdown
   ## Related Documents
   - [Skills Journey Architecture](../hub/SkillsJourneyArchitecture.md)
   - [Weekly Plan Feb 9](../Weekly Plan/2026-02-09/README.md)
   - [Team Member: Avery](../teammembers/Avery/README.md)
   ```

### Phase 5: Create Backlinks

1. **Identify Current Document**
   - File path: `{meeting_notes}/2026-02-09-skills-journey.md`
   - Title: Skills Journey Architecture Review

2. **Find Documents that Link Here**
   Search for references to this document:
   ```bash
   grep -r "skills-journey.md" /path/to/docs/
   grep -r "Skills Journey Architecture Review" /path/to/docs/
   ```

3. **Generate Backlinks Section**
   Add to current document:
   ```markdown
   ## Referenced By
   - [Weekly Plan Feb 9](../Weekly Plan/2026-02-09/README.md) - Action item: Review architecture
   - [Avery 1:1 Notes](../teammembers/Avery/1on1-2026-02-12.md) - Discussed ownership
   ```

4. **Update Referenced Documents**
   Add forward links to documents that should link here:
   ```markdown
   ## Related Documents
   - [Skills Journey Architecture Review](../meeting-notes/2026-02-09-skills-journey.md) - Architecture discussion
   ```

### Phase 6: Handle Special Cases

1. **Short-form References**
   Convert short references to full links:
   ```markdown
   Before: See SE-1234 for details
   After: See [SE-1234: Feature description](https://udemy.atlassian.net/browse/SE-1234) for details
   ```

2. **Already Formatted Links**
   Update stale titles if needed:
   ```markdown
   Before: [SE-1234: Old title](URL)
   After: [SE-1234: Updated title](URL)
   ```

3. **Broken Links**
   Flag and suggest fixes:
   ```markdown
   ⚠️ [Broken Link](./missing-file.md) - File not found
   Suggestion: Update to [Correct Link](./correct-file.md)
   ```

4. **Duplicate Links**
   Consolidate multiple references to the same URL:
   ```markdown
   First mention: [SE-1234: Full title](URL)
   Subsequent: [SE-1234](URL) (abbreviated)
   ```

### Phase 7: Validation and Output

1. **Validate Links**
   - Check that all URLs are reachable (optional)
   - Verify markdown syntax is correct
   - Ensure titles were successfully fetched

2. **Generate Summary**
   ```markdown
   ## Link Processing Summary
   - URLs found: 12
   - Converted to markdown: 12
   - Titles fetched: 10
   - Generic titles: 2
   - Related documents suggested: 5
   ```

3. **Output Options**
   - **In-place**: Update the current document
   - **Preview**: Show changes without modifying file
   - **Report**: Generate list of all links and their status

## Edge Cases

### Missing API Credentials
If API tokens are not available:
- Fall back to generic title extraction
- Use placeholder: `[Jira Ticket SE-1234](URL)`
- Suggest manual title update

### API Rate Limits
If APIs are rate-limited:
- Process in batches
- Cache fetched titles
- Provide partial results with note

### Private Resources
If URL requires authentication:
- Note that title couldn't be fetched
- Use generic format with resource ID
- Suggest manual verification

### Malformed URLs
If URL is incomplete or broken:
- Flag for user review
- Suggest correction if pattern is clear
- Don't modify if uncertain

### Very Large Documents
If document has hundreds of URLs:
- Ask user to confirm before processing
- Process in batches
- Show progress

## Output Format

The linked document should have:
- ✅ All URLs converted to markdown links
- 📋 Proper titles fetched from APIs
- 🔗 Related documents section
- ⬅️ Backlinks section (if applicable)
- ✨ Clean, readable formatting

## Tools to Use

- **Read**: Read document to process
- **Edit**: Update document with formatted links (or Write to create new version)
- **Bash**: Execute API calls to fetch titles
- **Grep**: Search for related documents

## Best Practices

- Always preserve original URLs (don't break links)
- Include resource IDs in link text (e.g., "SE-1234", "PR #123")
- Keep link text concise but descriptive
- Group related links together
- Update stale titles periodically
- Maintain consistent formatting across documents

## Related Skills

- **process-meeting**: Meeting notes often contain many URLs to link
- **docs-hub**: Hub documents should link to detailed docs
- **track-actions**: Action items often reference Jira/GitHub

## Example Usage Patterns

1. **Format Single Document**
   ```
   user: "Convert all URLs in this weekly plan to proper markdown links"
   skill: Processes document, fetches 15 titles, updates in place
   ```

2. **Fetch Title for URL**
   ```
   user: "What's the title of this Jira ticket? SE-1234"
   skill: Fetches title, provides formatted markdown link
   ```

3. **Find Related Documents**
   ```
   user: "What other documents mention Skills Journey?"
   skill: Searches docs, provides list of related files
   ```

4. **Create Backlinks**
   ```
   user: "Show me what documents link to this meeting note"
   skill: Scans all docs, generates backlinks section
   ```

## Scripts and References

Use these helper scripts:
- `~/.claude/skills/link-docs/scripts/fetch_jira_title.sh` - Fetch Jira ticket title
- `~/.claude/skills/link-docs/scripts/fetch_github_title.sh` - Fetch GitHub PR/issue title
- `~/.claude/skills/link-docs/scripts/extract_html_title.sh` - Extract title from HTML page

Reference file:
- `~/.claude/skills/link-docs/references/url-patterns.md` - Regex patterns for each service
