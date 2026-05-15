#!/bin/bash
# Fetch GitHub PR or Issue title
# Usage: ./fetch_github_title.sh udemy/repo 123 pr
# Usage: ./fetch_github_title.sh udemy/repo 42 issue

REPO="$1"
NUMBER="$2"
TYPE="$3" # pr or issue

if [ -z "$REPO" ] || [ -z "$NUMBER" ] || [ -z "$TYPE" ]; then
    echo "Usage: $0 REPO NUMBER TYPE"
    echo "Example: $0 udemy/coding-labs 123 pr"
    exit 1
fi

# Use GitHub CLI (preferred method)
if command -v gh &> /dev/null; then
    if [ "$TYPE" = "pr" ]; then
        TITLE=$(gh pr view "$NUMBER" --repo "$REPO" --json title -q .title 2>/dev/null)
        TYPE_LABEL="PR"
    elif [ "$TYPE" = "issue" ]; then
        TITLE=$(gh issue view "$NUMBER" --repo "$REPO" --json title -q .title 2>/dev/null)
        TYPE_LABEL="Issue"
    else
        echo "Error: TYPE must be 'pr' or 'issue'"
        exit 1
    fi

    if [ -z "$TITLE" ]; then
        echo "Error: Could not fetch title for ${REPO} ${TYPE} #${NUMBER}"
        exit 1
    fi

    # Output formatted markdown link
    URL="https://github.com/${REPO}/${TYPE}/${NUMBER}"
    echo "[${TYPE_LABEL} #${NUMBER}: ${TITLE}](${URL})"
else
    echo "Error: GitHub CLI (gh) not installed"
    echo "Install with: brew install gh"
    exit 1
fi
