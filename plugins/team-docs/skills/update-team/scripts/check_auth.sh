#!/bin/bash
# Check authentication status for GitHub, Jira, and Confluence
# Usage: ./check_auth.sh

echo "Checking authentication status..."
echo ""

# Check GitHub CLI
echo "🔍 GitHub CLI:"
if ! command -v gh &> /dev/null; then
    echo "  ❌ GitHub CLI not installed"
    echo "     Install with: brew install gh"
    exit_code=1
else
    if gh auth status &> /dev/null; then
        gh_user=$(gh api user --jq '.login' 2>/dev/null)
        echo "  ✅ Authenticated as: $gh_user"
    else
        echo "  ❌ Not authenticated"
        echo "     Run: gh auth login"
        exit_code=1
    fi
fi

echo ""

# Check Jira Token
echo "🔍 Jira:"
if [ -z "$JIRA_TOKEN" ]; then
    echo "  ⚠️  JIRA_TOKEN not set (optional)"
    echo "     Set with: export JIRA_TOKEN='your_token'"
else
    echo "  ✅ JIRA_TOKEN is set"
fi

echo ""

# Check Confluence Token
echo "🔍 Confluence:"
if [ -z "$CONFLUENCE_TOKEN" ]; then
    echo "  ⚠️  CONFLUENCE_TOKEN not set (optional)"
    echo "     Set with: export CONFLUENCE_TOKEN='your_token'"
else
    echo "  ✅ CONFLUENCE_TOKEN is set"
fi

echo ""

# Check team directory
echo "🔍 Team Directory:"
TEAM_DIR="/Users/trey.briggs/Code/documentation/work/udemy/teammembers"
if [ -d "$TEAM_DIR" ]; then
    member_count=$(find "$TEAM_DIR" -maxdepth 1 -type d | grep -v "^$TEAM_DIR$" | wc -l | tr -d ' ')
    echo "  ✅ Found $member_count team member directories"
else
    echo "  ❌ Team directory not found: $TEAM_DIR"
    exit_code=1
fi

echo ""

# Check scripts
echo "🔍 Update Scripts:"
SCRIPT_DIR="/Users/trey.briggs/Code/documentation/scripts"
if [ -f "$SCRIPT_DIR/update_team_activity.py" ]; then
    echo "  ✅ update_team_activity.py found"
else
    echo "  ❌ update_team_activity.py not found"
    exit_code=1
fi

if [ -f "$SCRIPT_DIR/update_team_prs.py" ]; then
    echo "  ✅ update_team_prs.py found"
else
    echo "  ❌ update_team_prs.py not found"
    exit_code=1
fi

echo ""

if [ ${exit_code:-0} -eq 0 ]; then
    echo "✅ All checks passed! Ready to update team profiles."
    exit 0
else
    echo "❌ Some checks failed. Fix the issues above before proceeding."
    exit 1
fi
