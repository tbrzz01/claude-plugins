---
name: update-team
description: |
  Update team member profiles with GitHub/Jira activity. Use this skill when the user asks to "update team activity", "refresh team profiles", "fetch team PRs", "update GitHub activity", "sync team member data", or wants to update README files with recent work.

  This skill wraps existing Python scripts with proper error handling, authentication validation, and summary reporting. It can update all team members or specific individuals.

  <example>
  Context: User wants to refresh team activity before weekly planning
  user: "Update all team member profiles with this week's activity"
  assistant: "I'll update all team member profiles with recent GitHub, Jira, and Confluence activity."
  <commentary>
  The skill will validate auth, run the update scripts, and provide a summary of changes made.
  </commentary>
  </example>
---

# Update Team Skill

## Description
Enhanced wrapper around existing Python scripts (`update_team_activity.py`, `update_team_prs.py`) that updates team member README files with recent GitHub, Jira, and Confluence activity. Provides proper error handling, authentication validation, parallel execution where possible, and summary reporting.

## Input
- No parameters required (updates all team members)
- Optional: `--member "Name"` - Update specific team member only
- Optional: `--since <days>` - Customize time window (default: 7 days)
- Optional: `--dry-run` - Preview what would be updated without making changes

## Instructions

### Phase 1: Pre-Flight Checks

1. **Validate Authentication**
   Check for required authentication:

   **GitHub CLI:**
   ```bash
   gh auth status
   ```
   - If not authenticated: Provide instructions to run `gh auth login`
   - GitHub CLI is REQUIRED for fetching PR data

   **Jira (Optional):**
   - Check for `JIRA_TOKEN` environment variable
   - If not set: Warn that Jira tickets won't be populated
   - Not required but recommended

   **Confluence (Optional):**
   - Check for `CONFLUENCE_TOKEN` environment variable
   - If not set: Warn that Confluence docs won't be populated
   - Not required but recommended

2. **Verify Scripts Exist**
   Check that scripts are present:
   - `/Users/trey.briggs/Code/documentation/scripts/update_team_activity.py`
   - `/Users/trey.briggs/Code/documentation/scripts/update_team_prs.py`
   - `/Users/trey.briggs/Code/documentation/scripts/generate_pr_report.py`

   If missing, provide error message with script paths

3. **Verify Team Directory**
   - Path: `/Users/trey.briggs/Code/documentation/work/udemy/teammembers/`
   - Check directory exists and contains team member folders
   - Use script: `~/.claude/skills/update-team/scripts/check_auth.sh`

### Phase 2: Determine Scope

1. **Read Team Roster**
   - Path: `/Users/trey.briggs/Code/documentation/work/udemy/teammembers/myteam.md`
   - Parse table to get list of all team members
   - Extract: Name, GitHub handle, email

2. **Filter by Member (if specified)**
   If user provided `--member "Name"`:
   - Find matching team member in roster
   - Update only that person's README
   - If no match found, list available names

3. **Determine Time Window**
   Default: Last 7 days (current week)
   - User can specify different window: `--since 30` (last 30 days)
   - Calculate date range for display

### Phase 3: Update Team Activity

1. **Run update_team_activity.py Script**
   ```bash
   python3 /Users/trey.briggs/Code/documentation/scripts/update_team_activity.py \
       --team-dir /Users/trey.briggs/Code/documentation/work/udemy/teammembers
   ```

   This script:
   - Creates new "Past Week Activity" sections in each README
   - Adds placeholders for GitHub, Jira, Confluence data
   - Inserts section after "About" section
   - Does NOT populate actual data (Phase 4 does that)

2. **Handle Errors**
   - Capture stderr and stdout
   - If script fails, provide clear error message
   - Common errors:
     - Directory not found
     - README file missing
     - Permission issues
     - Invalid markdown structure

3. **Track Updated Files**
   - Count how many README files were modified
   - Store list for summary report

### Phase 4: Fetch and Populate GitHub Activity

1. **Run update_team_prs.py Script**
   ```bash
   python3 /Users/trey.briggs/Code/documentation/scripts/update_team_prs.py
   ```

   This script:
   - Reads myteam.md for team member GitHub handles
   - Uses `gh search prs` to fetch PRs from last 6 months
   - Updates "Recent GitHub Activity (Last 6 Months)" section
   - Calculates cycle times (time from open to merge/close)
   - Formats as markdown table in README

2. **Handle Rate Limiting**
   - GitHub API has rate limits
   - If rate limited, provide helpful message:
     - Wait time until reset
     - Suggest updating fewer members at once
     - Option to continue with partial data

3. **Handle Missing Data**
   - If team member has no recent PRs, note that in README
   - If GitHub handle not in GitHub, note that handle may be wrong
   - Continue with other team members on error

4. **Parallel Execution (if possible)**
   - Team members can be updated independently
   - Consider using GNU parallel or xargs for speed
   - Limit concurrency to avoid rate limits (max 5 parallel)

### Phase 5: Generate Summary Report

1. **Calculate Statistics**
   - Total team members processed
   - READMEs updated successfully
   - Total PRs added across all members
   - Average cycle time (for merged PRs)
   - Top contributors (by PR count)
   - Failed updates (if any)

2. **Generate Summary Output**
   ```markdown
   # Team Activity Update Summary
   Generated: {current date and time}
   Time window: {start date} to {end date}

   ## Overview
   - **Team members processed:** {count}
   - **READMEs updated:** {count}
   - **Total PRs fetched:** {count}
   - **Average cycle time:** {time}

   ## Top Contributors (by PR count)
   1. {Name}: {count} PRs (avg cycle time: {time})
   2. {Name}: {count} PRs (avg cycle time: {time})
   3. {Name}: {count} PRs (avg cycle time: {time})

   ## Longest Cycle Times
   - {PR title} - {Repo} by {Name}: {time}
   - {PR title} - {Repo} by {Name}: {time}

   ## Activity by Team Member
   | Name | PRs | Avg Cycle Time | Status |
   |------|-----|----------------|--------|
   | {Name} | {count} | {time} | ✅ Updated |
   | {Name} | {count} | {time} | ✅ Updated |
   | {Name} | 0 | — | ⚠️ No activity |

   ## Issues Encountered
   {list any errors or warnings}

   ## Next Steps
   - Review updated READMEs for accuracy
   - Use data for weekly planning and 1:1s
   - Consider running `track-actions` to see team commitments
   ```

### Phase 6: Dry Run Mode (if requested)

If `--dry-run` flag is provided:

1. **Preview Changes**
   - Show which READMEs would be updated
   - List PRs that would be added
   - Display cycle time calculations
   - Do NOT write any files

2. **Sample Output**
   ```markdown
   # Dry Run: Team Activity Update

   ## Would update these README files:
   - /Users/trey.briggs/Code/documentation/work/udemy/teammembers/Eyupcan Bodur/README.md
   - /Users/trey.briggs/Code/documentation/work/udemy/teammembers/Jason Diaz/README.md
   - [... 20 more files]

   ## Sample data for Eyupcan Bodur:
   Would add 15 PRs from last 6 months:
   - service-open-badge-issuance #594: Add CredlyIssuanceRecord table (Open)
   - service-open-badge-issuance #593: Add issue credly badge (Open)
   - service-api-gateway #827: feat: update namespace (Merged, 40m cycle time)
   [... more PRs]

   ## To actually update:
   Run without --dry-run flag
   ```

## Enhanced Features

### Filter by Team/Pod
```bash
--team "Skills Enablement"
--pod "Technical Skills Mastery"
```
Only update members of specific team or pod.

### Export Summary
```bash
--export summary.md
```
Save summary report to file for sharing or archiving.

### Quiet Mode
```bash
--quiet
```
Only show errors and final summary, no progress output.

### Since Date
```bash
--since 30  # Last 30 days
--since 90  # Last 90 days
```
Customize PR fetch window (default is 6 months).

## Output Format

### Success Case
```
🔄 Updating team member profiles...

✅ Authentication validated
   - GitHub CLI: Authenticated as trey.briggs
   - Jira: Token found
   - Confluence: Token found

📋 Processing 22 team members...

▶ Updating Eyupcan Bodur...
  ✓ README updated with activity section
  ✓ Fetched 15 PRs (last 6 months)
  ✓ Average cycle time: 2h 15m

▶ Updating Jason Diaz...
  ✓ README updated with activity section
  ✓ Fetched 8 PRs (last 6 months)
  ✓ Average cycle time: 4h 30m

[... progress for each member]

✅ Update complete!

📊 Summary: 22 members processed, 165 PRs fetched, avg cycle time 3h 20m
```

### Error Case
```
❌ Error: GitHub CLI not authenticated

Please run:
  gh auth login

Then try again.
```

## Edge Cases

### Team Member Without GitHub Handle
- Skip GitHub PR fetching for that person
- Note in summary: "No GitHub handle provided"
- Still update activity section structure

### Empty PR History
- README shows: "No recent PRs found"
- Not an error, just low activity period
- Note in summary

### Script Path Changes
- If scripts moved, detect and ask user for new paths
- Or provide instructions to update skill configuration

### Large Team (50+ members)
- Update in batches to avoid rate limits
- Show progress bar/percentage
- Estimate time remaining

### Concurrent Runs
- Check if another update is in progress (lock file)
- Warn user and ask if they want to force run
- Prevent file corruption from parallel writes

## Tools to Use

- **Bash**: Execute Python scripts, gh CLI commands
- **Read**: Read team roster and README files
- **Edit**: Update README files with activity data
- **Grep**: Search for existing activity sections

## Best Practices

- Always validate auth before running
- Show progress for long-running operations
- Provide clear error messages with remediation steps
- Don't fail entire operation if one member fails
- Calculate and show meaningful metrics (cycle times, top contributors)
- Format output to be both human-readable and machine-parseable

## Related Skills

- **new-team-member**: After creating a profile, use this skill to populate initial activity
- **track-actions**: Combine with action tracking for comprehensive team overview
- **weekly-review**: Use updated team data for weekly planning

## Example Usage Patterns

1. **Weekly Update**
   ```
   user: "Update all team member profiles"
   skill: Runs full update, provides summary
   ```

2. **Single Member**
   ```
   user: "Update GitHub activity for Eyupcan"
   skill: Updates only Eyupcan's README
   ```

3. **Before 1:1s**
   ```
   user: "Refresh Jason's profile before our 1:1"
   skill: Updates Jason's README with latest activity
   ```

4. **Dry Run Check**
   ```
   user: "Show me what would be updated (dry run)"
   skill: Previews changes without writing files
   ```

## Integration with Existing Scripts

### update_team_activity.py
- Creates "Past Week Activity" section structure
- Adds placeholders for data
- Handles section insertion logic
- Run FIRST before update_team_prs.py

### update_team_prs.py
- Fetches actual PR data via gh CLI
- Populates "Recent GitHub Activity" section
- Calculates cycle times
- Run SECOND after activity sections exist

### generate_pr_report.py
- Generates aggregate reports across team
- Optional: use for summary statistics
- Can provide insights on team velocity

## Error Messages and Remediation

| Error | Cause | Fix |
|-------|-------|-----|
| "GitHub CLI not found" | gh not installed | `brew install gh` |
| "Not authenticated" | No GitHub auth | `gh auth login` |
| "Team directory not found" | Wrong path | Check path in skill config |
| "README not found" | Missing README for member | Run `new-team-member` skill first |
| "Rate limit exceeded" | Too many API calls | Wait or reduce batch size |
| "Invalid JSON response" | GitHub API error | Retry or check API status |
