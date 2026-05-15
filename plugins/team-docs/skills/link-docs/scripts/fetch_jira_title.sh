#!/bin/bash
# Fetch Jira ticket title
# Usage: ./fetch_jira_title.sh SE-1234

TICKET_ID="$1"

if [ -z "$TICKET_ID" ]; then
    echo "Usage: $0 TICKET_ID"
    exit 1
fi

if [ -z "$JIRA_TOKEN" ]; then
    echo "Error: JIRA_TOKEN environment variable not set"
    exit 1
fi

# Fetch ticket summary from Jira API
TITLE=$(curl -s "https://udemy.atlassian.net/rest/api/3/issue/${TICKET_ID}" \
    -H "Authorization: Bearer ${JIRA_TOKEN}" \
    | jq -r '.fields.summary')

if [ "$TITLE" = "null" ] || [ -z "$TITLE" ]; then
    echo "Error: Could not fetch title for ${TICKET_ID}"
    exit 1
fi

# Output formatted markdown link
echo "[${TICKET_ID}: ${TITLE}](https://udemy.atlassian.net/browse/${TICKET_ID})"
