# Sample Output: Update Team Skill

This is an example of what the update-team skill outputs.

---

## Successful Update Run

```
🔄 Updating team member profiles...

✅ Authentication validated
   - GitHub CLI: Authenticated as trey.briggs
   - Jira: Token found
   - Confluence: Token found

📋 Processing 22 team members from roster...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

▶ Updating Eyupcan Bodur...
  ✓ README updated with activity section
  ✓ Fetched 15 PRs (last 6 months)
  ✓ Average cycle time: 2h 15m

▶ Updating Jason Diaz...
  ✓ README updated with activity section
  ✓ Fetched 8 PRs (last 6 months)
  ✓ Average cycle time: 4h 30m

▶ Updating Charles Pham...
  ✓ README updated with activity section
  ✓ Fetched 12 PRs (last 6 months)
  ✓ Average cycle time: 1h 45m

▶ Updating Dibyendu Tiwari...
  ✓ README updated with activity section
  ✓ Fetched 10 PRs (last 6 months)
  ✓ Average cycle time: 3h 10m

▶ Updating Manuel Gutierrez...
  ✓ README updated with activity section
  ✓ Fetched 6 PRs (last 6 months)
  ✓ Average cycle time: 5h 20m

[... progress continues for all 22 members ...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Update complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Summary Report

```markdown
# Team Activity Update Summary
Generated: Feb 16, 2026 at 3:45 PM
Time window: Aug 16, 2025 to Feb 16, 2026 (6 months)

## Overview
- **Team members processed:** 22
- **READMEs updated:** 22
- **Total PRs fetched:** 165
- **Average cycle time:** 3h 20m

## Top Contributors (by PR count)

1. **Eyupcan Bodur**: 15 PRs (avg cycle time: 2h 15m)
   - Most active in: frontends-learner-experience, service-mcp-chatgpt

2. **Charles Pham**: 12 PRs (avg cycle time: 1h 45m)
   - Most active in: coding-labs, website-django

3. **Dibyendu Tiwari**: 10 PRs (avg cycle time: 3h 10m)
   - Most active in: service-api-gateway, website-django

4. **Jason Diaz**: 8 PRs (avg cycle time: 4h 30m)
   - Most active in: frontends-learner-experience

5. **Ying Rao**: 7 PRs (avg cycle time: 2h 50m)
   - Most active in: frontends-learner-experience

## Fastest Merge Times (< 1 hour)

- **service-api-gateway #827** by Eyupcan Bodur: 40m
  - "feat: update namespace for frontends-pro-assessments URI"

- **service-mcp-chatgpt #236** by Eyupcan Bodur: 15m
  - "feat: update cookie domain and remove secure"

- **frontends-components-v2 #571** by Eyupcan Bodur: 16m
  - "feat: fixing on player ready synchronization"

## Longest Cycle Times

- **frontends-learner-experience #710** by Eyupcan Bodur: 45d 8h (Draft/Open)
  - "feat: client routing with react-router"

- **i18n #18** by Eyupcan Bodur: 15d 20h
  - "fix: revert 'feat: update import of quiz'"

- **service-api-gateway #815** by Joao Cavalcanti: 12d 5h
  - "feat: add new learning path endpoints"

## Activity by Team Member

| Name | PRs | Open | Merged | Closed | Avg Cycle Time | Status |
|------|-----|------|--------|--------|----------------|--------|
| Eyupcan Bodur | 15 | 2 | 11 | 2 | 2h 15m | ✅ Updated |
| Jason Diaz | 8 | 1 | 6 | 1 | 4h 30m | ✅ Updated |
| Charles Pham | 12 | 0 | 10 | 2 | 1h 45m | ✅ Updated |
| Dibyendu Tiwari | 10 | 1 | 8 | 1 | 3h 10m | ✅ Updated |
| Manuel Gutierrez | 6 | 0 | 5 | 1 | 5h 20m | ✅ Updated |
| Leonardo Ingalls | 5 | 1 | 4 | 0 | 6h 15m | ✅ Updated |
| Iván Delgado | 7 | 0 | 7 | 0 | 2h 40m | ✅ Updated |
| Carlos Sánchez | 4 | 0 | 4 | 0 | 3h 50m | ✅ Updated |
| Ying Rao | 7 | 1 | 5 | 1 | 2h 50m | ✅ Updated |
| Jackson McIntyre | 3 | 0 | 3 | 0 | 4h 5m | ✅ Updated |
| Alex Hwang | 8 | 1 | 7 | 0 | 3h 25m | ✅ Updated |
| Joao Cavalcanti | 11 | 1 | 9 | 1 | 5h 10m | ✅ Updated |
| Shanshan Huan | 6 | 0 | 6 | 0 | 2h 30m | ✅ Updated |
| Maisa Basher | 5 | 1 | 4 | 0 | 4h 20m | ✅ Updated |
| Linus Martinez | 9 | 2 | 6 | 1 | 3h 5m | ✅ Updated |
| Matthew Hearn | 0 | 0 | 0 | 0 | — | ⚠️ No activity |
| William Chandler | 10 | 1 | 8 | 1 | 2h 55m | ✅ Updated |
| Luke Smith | 4 | 0 | 4 | 0 | 5h 45m | ✅ Updated |
| Mei Wong | 6 | 0 | 5 | 1 | 3h 35m | ✅ Updated |
| Evan Eustace | 12 | 2 | 9 | 1 | 4h 10m | ✅ Updated |
| Abbas Hachem | 0 | 0 | 0 | 0 | — | ⚠️ No longer at company |
| Seth Hodgson | 0 | 0 | 0 | 0 | — | ⚠️ No longer at company |

## Repository Activity

Top repositories by team contribution:

1. **frontends-learner-experience**: 45 PRs
2. **website-django**: 32 PRs
3. **service-api-gateway**: 18 PRs
4. **frontends-components-v2**: 15 PRs
5. **service-mcp-chatgpt**: 12 PRs
6. **coding-labs**: 10 PRs
7. **datainfra-sparkapps**: 8 PRs
8. **service-open-badge-issuance**: 6 PRs

## Issues Encountered

None - all updates completed successfully!

## Next Steps

- ✅ All team member READMEs are up to date with latest GitHub activity
- 📊 Use this data for weekly planning and 1:1 meetings
- 🎯 Consider running `track-actions` to see open commitments
- 📝 Review team members with no recent activity (Matthew Hearn)
- 🔄 Schedule next update for: Feb 23, 2026 (1 week)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Dry Run Output

```
# Dry Run: Team Activity Update

This is a preview of what would be updated. No files will be modified.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Would update these README files:

1. /Users/trey.briggs/Code/documentation/work/udemy/teammembers/Eyupcan Bodur/README.md
2. /Users/trey.briggs/Code/documentation/work/udemy/teammembers/Jason Diaz/README.md
3. /Users/trey.briggs/Code/documentation/work/udemy/teammembers/Charles Pham/README.md
[... 19 more files]

## Sample data for Eyupcan Bodur:

Would add "Past Week Activity (Feb 10-16, 2026)" section

Would add these PRs to "Recent GitHub Activity (Last 6 Months)":
| Repo | PR | Title | Status | Closed | Cycle Time |
|------|----|-------|--------|--------|------------|
| service-open-badge-issuance | [#594](https://github.com/udemy/service-open-badge-issuance/pull/594) | Add CredlyIssuanceRecord table | Open | — | — |
| service-open-badge-issuance | [#593](https://github.com/udemy/service-open-badge-issuance/pull/593) | Add issue credly badge | Open | — | — |
| service-api-gateway | [#827](https://github.com/udemy/service-api-gateway/pull/827) | feat: update namespace | ✅ Merged | 2025-12-17 | 40m |
[... 12 more PRs]

## Sample data for Jason Diaz:

Would add "Past Week Activity (Feb 10-16, 2026)" section

Would add 8 PRs from last 6 months (avg cycle time: 4h 30m)

[... similar previews for other team members]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Summary Statistics

- Total READMEs to update: 22
- Total PRs to add: 165
- Overall average cycle time: 3h 20m
- Estimated update time: ~2 minutes

To actually perform the update, run without --dry-run flag:
  /update-team
```

---

## Error Case: Not Authenticated

```
❌ Error: GitHub CLI not authenticated

Authentication check failed:
  ✓ GitHub CLI installed
  ❌ Not authenticated with GitHub

Please run:
  gh auth login

Select these options:
  - GitHub.com
  - HTTPS protocol
  - Authenticate via web browser

Then try running update-team again.
```

---

## Single Member Update

```
🔄 Updating team member profile for: Eyupcan Bodur

✅ Authentication validated

▶ Updating Eyupcan Bodur...
  ✓ README updated with activity section
  ✓ Fetched 15 PRs (last 6 months)
  ✓ Average cycle time: 2h 15m

  Recent PRs:
  - service-open-badge-issuance #594: Open
  - service-open-badge-issuance #593: Open
  - service-api-gateway #827: Merged (40m)
  - frontends-pro-assessments #16: Closed
  - website-django #100818: Merged (1h 41m)
  [... 10 more PRs]

✅ Update complete for Eyupcan Bodur!

📊 Summary: 1 member processed, 15 PRs fetched, avg cycle time 2h 15m
```

---

## Notes on This Sample

This example demonstrates:

1. **Progress Indicators**: Clear visual feedback during long-running operations
2. **Summary Statistics**: Meaningful metrics about team activity
3. **Top Contributors**: Recognition of most active team members
4. **Cycle Time Analysis**: Insights into PR velocity
5. **Error Handling**: Clear messages when things go wrong
6. **Dry Run Mode**: Preview before making changes
7. **Single Member Mode**: Focused updates for specific people
8. **Repository Breakdown**: Understanding where team works most

The skill generates comprehensive, actionable output.
