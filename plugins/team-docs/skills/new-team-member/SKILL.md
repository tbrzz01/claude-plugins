---
name: new-team-member
description: |
  Create a new team member profile from template. Use this skill when the user asks to "add new team member", "create team profile", "onboard new engineer", "set up new hire documentation", or wants to create a profile for a new team member.

  This skill automates the creation of team member profiles with proper directory structure, README template, and optional initial GitHub activity fetching.

  <example>
  Context: New engineer joining the team
  user: "Can you create a profile for our new hire, Sarah Chen?"
  assistant: "I'll create a new team member profile. Let me gather the necessary information."
  <commentary>
  The skill will interactively collect details (name, GitHub handle, role, location, email, team) and create a complete profile directory with README.
  </commentary>
  </example>
---

# New Team Member Skill

## Description
Creates a new team member profile directory with a properly formatted README.md file, including GitHub information, role details, and activity tracking templates. Optionally fetches initial GitHub PR history if a handle is provided.

## Input
The skill will interactively prompt for:
- **Full Name** (e.g., "Eyupcan Bodur")
- **GitHub Handle** (e.g., "bodureyupcan")
- **Role/Level** (e.g., "Staff Software Engineer", "IC4", "M3")
- **Team/Pod** (e.g., "Skills Enablement", "Technical Skills Mastery")
- **Location** (e.g., "Austin, TX", "Istanbul, Turkey", "CDMX")
- **Email** (e.g., "firstname.lastname@udemy.com")
- **Hire Date** (optional, e.g., "2026-02-16")

## Instructions

### Phase 1: Gather Information

1. **Prompt User for Details**
   Use interactive prompts to collect:
   - Full name of the team member
   - GitHub handle (without @ symbol)
   - Role and level (IC1, IC2, IC3, IC4, M3, etc.)
   - Team or pod assignment
   - Location (city, state/country)
   - Email address
   - Hire date (optional, can be filled in later)

2. **Validate Information**
   - Ensure name is not empty
   - GitHub handle should be alphanumeric (no spaces)
   - Email should follow pattern: firstname.lastname@udemy.com
   - Location should be formatted consistently with existing profiles
   - Refer to: `~/.claude/skills/new-team-member/references/role-levels.md`

3. **Show Summary for Confirmation**
   Display collected information and ask user to confirm before creating files

### Phase 2: Create Directory Structure

1. **Create Team Member Directory**
   - Base path: `/Users/trey.briggs/Code/documentation/work/udemy/teammembers/`
   - Directory name: Use full name as provided
   - Full path: `/Users/trey.briggs/Code/documentation/work/udemy/teammembers/{Full Name}/`
   - Example: `/Users/trey.briggs/Code/documentation/work/udemy/teammembers/Sarah Chen/`

2. **Check for Existing Directory**
   - If directory already exists, ask user if they want to:
     - Overwrite existing profile
     - Cancel operation
     - Update specific fields only

### Phase 3: Generate README Template

1. **Create README.md Structure**
   Use this template (adapt values from collected information):

```markdown
# {Full Name}

- **GitHub:** [{github_handle}](https://github.com/{github_handle})
- **Team:** {Team/Pod}
- **Role:** {Role}
- **Hire Date:** {YYYY-MM-DD or "TBD"}
- **Location:** {Location}

## About
{Full Name} is a {Role} specializing in {area - leave blank or prompt user for a brief description}.

## Notes

### Week of {current date}

[Space for 1:1 notes and action items]

## Recent GitHub Activity (Last 6 Months)

### PRs
| Repo | PR | Title | Status | Closed | Cycle Time |
|------|----|-------|--------|--------|------------|
| — | — | Populate via update-team skill | — | — | — |

## Past Week Activity ({date range})

### GitHub Contributions
| Repository | PR/Issue | Title | Status | Date |
|------------|----------|-------|--------|------|
| — | — | Populate via script with GH auth | — | — |

### Jira Tickets
| Ticket | Title | Priority | Status | Updated |
|--------|-------|----------|--------|---------|
| — | Provide JIRA_TOKEN to populate | — | — | — |

### Confluence Documents
| Document | Type | Status |
|----------|------|--------|
| — | Provide CONFLUENCE_TOKEN to populate | — |

*Last updated: {current date}*
```

2. **Write README.md File**
   - Path: `/Users/trey.briggs/Code/documentation/work/udemy/teammembers/{Full Name}/README.md`
   - Use Write tool to create the file
   - Preserve proper markdown formatting

### Phase 4: Fetch Initial GitHub Activity (Optional)

1. **Check if GitHub Handle Provided**
   - If yes, offer to fetch initial PR history
   - Ask user: "Would you like me to fetch their recent GitHub activity?"

2. **Fetch Recent PRs**
   If user agrees:
   - Use GitHub CLI: `gh pr list --author {github_handle} --repo udemy/* --limit 20 --state all --json number,title,state,closedAt,repository`
   - Parse the JSON response
   - Calculate cycle times where applicable
   - Update the "Recent GitHub Activity" section

3. **Use Script Helper**
   - Script: `~/.claude/skills/new-team-member/scripts/fetch_initial_prs.sh {github_handle}`
   - This script wraps the gh CLI commands and formats output

### Phase 5: Update Team Roster

1. **Read Team Roster**
   - Path: `/Users/trey.briggs/Code/documentation/work/udemy/teammembers/myteam.md`
   - Parse the table structure

2. **Determine Team Section**
   - Based on team/pod provided, add to appropriate section:
     - Skills Enablement
     - Technical Skills Mastery (Services or Experiences)
     - Other (if new team section needed)

3. **Add New Entry**
   Add a new row to the team table:
   ```markdown
   | {Full Name} | {Level} | {Location} | {github_handle} | {email} | {Team} |
   ```
   - Maintain consistent spacing and alignment with existing entries
   - Insert in appropriate section (by team)
   - Consider alphabetical sorting within team section

4. **Write Updated Roster**
   - Use Edit tool to add the new row in the correct location
   - Preserve existing formatting and structure

### Phase 6: Summary and Next Steps

1. **Generate Summary Report**
   Report to user:
   ```markdown
   ## Team Member Profile Created

   **Name:** {Full Name}
   **Location:** `/Users/trey.briggs/Code/documentation/work/udemy/teammembers/{Full Name}/README.md`

   ### Details
   - GitHub: @{github_handle}
   - Role: {Role}
   - Team: {Team}
   - Location: {Location}

   ### Next Steps
   - [ ] Fill in "About" section with more details
   - [ ] Add initial 1:1 notes if meeting scheduled
   - [ ] Run `update-team` skill to fetch GitHub activity
   - [ ] Set up first 1:1 meeting and add notes
   - [ ] Introduce to team and add to relevant channels
   ```

2. **Suggest Follow-up Actions**
   - Run `update-team --member "{Full Name}"` to populate GitHub activity
   - Add more details to About section
   - Schedule first 1:1 and add notes
   - Create onboarding checklist if needed

## Edge Cases

### Duplicate Name
If team member with same name exists:
- Check if it's truly a duplicate or different person
- Suggest using middle initial or full middle name
- Example: "John Smith" vs "John A. Smith"

### GitHub Handle Not Available Yet
- Leave GitHub field as: `[Pending](https://github.com)`
- Note in README: "GitHub handle to be provided"
- Can update later when handle is available

### Role/Level Unclear
- Ask user to clarify or leave as generic role title
- Examples: "Software Engineer", "Engineering Manager"
- Reference: `~/.claude/skills/new-team-member/references/role-levels.md`

### Email Format Different
- Standard format: firstname.lastname@udemy.com
- If different (e.g., shortened name), use what user provides
- Validate it ends with @udemy.com

### Location Not Standard
- Ask user for clarification
- Examples: "Remote, CA" (Remote in California)
- Use consistent format with existing profiles

## Tools to Use

- **Write**: Create README.md file
- **Edit**: Update team roster (myteam.md)
- **Read**: Read existing roster and templates
- **Bash**: Execute gh commands for fetching PRs
- **Glob**: Check if directory already exists

## Best Practices

- Always confirm information before creating files
- Use consistent formatting with existing profiles
- Preserve table alignment in team roster
- Include helpful placeholder text for sections to be filled later
- Make it clear what needs to be populated vs. what's complete
- Provide actionable next steps

## Related Skills

- **update-team**: After creating profile, use this to populate GitHub/Jira activity
- **new-week**: Can reference team members when creating weekly plans

## Example Usage Patterns

1. **New Hire Onboarding**
   ```
   user: "We have a new engineer starting Monday, Sarah Chen"
   skill: Prompts for details, creates complete profile
   ```

2. **Contractor Addition**
   ```
   user: "Add profile for contractor: Alex Rodriguez, IC2, Mexico City"
   skill: Creates profile with provided information
   ```

3. **Team Transfer**
   ```
   user: "Create profile for John who transferred from different org"
   skill: Prompts for details, notes it's a transfer in About section
   ```

## Integration Notes

This skill works best when:
- Team roster (myteam.md) is up to date
- GitHub handles are known or can be provided
- User has permissions to access team directory
- Followed by running `update-team` skill to populate activity

## Sample Profile Structure

Reference profiles to emulate:
- `/Users/trey.briggs/Code/documentation/work/udemy/teammembers/Eyupcan Bodur/README.md`
- Shows proper formatting for all sections
- Includes example PR tables, Jira tickets, Confluence docs
- Has well-structured notes sections
