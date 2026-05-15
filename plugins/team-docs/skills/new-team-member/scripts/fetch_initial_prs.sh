#!/bin/bash
# Fetch initial GitHub PR history for a team member
# Usage: ./fetch_initial_prs.sh <github_handle>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <github_handle>"
    exit 1
fi

GITHUB_HANDLE="$1"

# Check if gh CLI is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    echo "Install with: brew install gh"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with GitHub CLI"
    echo "Run: gh auth login"
    exit 1
fi

echo "Fetching PRs for @$GITHUB_HANDLE..."

# Fetch last 20 PRs (both open and closed) across udemy org
# Filter to last 6 months
SIX_MONTHS_AGO=$(date -v-6m "+%Y-%m-%d" 2>/dev/null || date -d "6 months ago" "+%Y-%m-%d")

gh search prs \
    --author "$GITHUB_HANDLE" \
    --owner udemy \
    --limit 50 \
    --json number,title,state,repository,closedAt,createdAt,mergedAt \
    --created ">=$SIX_MONTHS_AGO" \
    | jq -r '
        .[] |
        select(.repository.name | startswith("udemy/")) |
        [
            .repository.name | sub("udemy/"; ""),
            .number,
            .title,
            (if .mergedAt != null then "✅ Merged"
             elif .state == "OPEN" then "Open"
             else "❌ Closed" end),
            (if .closedAt != null then .closedAt[:10] else "—" end),
            (if .mergedAt != null and .createdAt != null then
                (((.mergedAt | fromdateiso8601) - (.createdAt | fromdateiso8601)) / 3600 | floor | tostring) + "h"
             else "—" end)
        ] | @tsv
    ' | sort -k5 -r

echo ""
echo "Fetch complete. Found PRs from last 6 months."
echo ""
echo "To format as markdown table:"
echo "| Repo | PR | Title | Status | Closed | Cycle Time |"
echo "|------|----|-------|--------|--------|------------|"
