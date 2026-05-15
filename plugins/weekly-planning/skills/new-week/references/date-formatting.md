# Date Formatting Reference

This document provides patterns and logic for date calculations in weekly plans.

## Weekly Plan Date Format

### Title Format
- Pattern: `# {MonthName} {Day}, {Year}`
- Examples:
  - `# Jan 20, 2026`
  - `# Dec 29, 2025`
  - `# Feb 3, 2026`

### File Name Format
- Pattern: `{NUMBER}-{MonthName} {Day}, {Year}.md`
- Number: 3-digit zero-padded (000, 001, 002, ...)
- Examples:
  - `000-Jan 20, 2026.md`
  - `001-Jan 27, 2026.md`
  - `042-Dec 29, 2025.md`

### Day Section Format
- Pattern: `### {DayName} ({M/D})`
- Examples:
  - `### Monday (1/27)`
  - `### Friday (12/5)`

## Date Calculation Logic

### Adding 7 Days (Next Week)
When calculating the next week's Monday:

1. Parse current date from title
2. Add 7 days
3. Handle month boundaries:
   - Jan (31 days), Feb (28/29), Mar (31), Apr (30), May (31), Jun (30)
   - Jul (31), Aug (31), Sep (30), Oct (31), Nov (30), Dec (31)
4. Handle year boundaries (Dec → Jan)

### Example Calculations

| Current Week | Next Week | Notes |
|--------------|-----------|-------|
| Jan 20, 2026 | Jan 27, 2026 | Simple addition |
| Jan 27, 2026 | Feb 3, 2026 | Month boundary |
| Dec 29, 2025 | Jan 5, 2026 | Year boundary |
| Feb 24, 2026 | Mar 3, 2026 | End of February |

### Using Bash for Date Calculation

```bash
# Option 1: Using date command (macOS compatible)
current_date="Jan 20, 2026"
next_week=$(date -j -f "%b %d, %Y" "$current_date" -v+7d "+%b %d, %Y")

# Option 2: Using date command (Linux)
current_date="Jan 20, 2026"
next_week=$(date -d "$current_date + 7 days" "+%b %d, %Y")

# Option 3: Parse manually
# Extract month, day, year
# Add 7 to day, handle overflow
```

## Month Name Abbreviations

| Full | Abbrev |
|------|--------|
| January | Jan |
| February | Feb |
| March | Mar |
| April | Apr |
| May | May |
| June | Jun |
| July | Jul |
| August | Aug |
| September | Sep |
| October | Oct |
| November | Nov |
| December | Dec |

## Day of Week Patterns

Weekly plans typically start on Monday and run through Friday:
- Monday
- Tuesday
- Wednesday
- Thursday
- Friday

Some weeks may include Saturday/Sunday if there are special activities.

## Short Week Handling

If a week is short (holiday, vacation), note it in priorities:
- Example: `**Short Week (Tues-Fri)**`
- Only include sections for working days

## Date Validation

Ensure calculated dates are valid:
- ✅ Jan 27, 2026 (valid)
- ✅ Feb 29, 2024 (leap year)
- ❌ Feb 29, 2026 (not a leap year)
- ❌ Nov 31, 2026 (November has 30 days)
- ❌ Jan 5, 2025 (if current is Jan 20, 2026 - going backwards)

## Current Date Context

When the skill runs, use the system date to understand context:
- If creating "next week", calculate from the most recent weekly plan date
- If creating "this week", use current system date
- If creating a specific date, use that date

## Timezone Considerations

- User is in Austin, TX (Central Time)
- Use local time for "current date" references
- Weekly plans start on Monday at 00:00 CT
