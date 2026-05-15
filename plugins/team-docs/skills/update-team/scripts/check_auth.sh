#!/bin/bash
# Check authentication status for GitHub, Jira, and Confluence,
# and verify team-docs paths from config.local.json.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONFIG_FILE="$PLUGIN_ROOT/config.local.json"
[ -f "$CONFIG_FILE" ] || CONFIG_FILE="$PLUGIN_ROOT/config.example.json"

if ! command -v jq &> /dev/null; then
    echo "Error: jq is required to read config.local.json (brew install jq)" >&2
    exit 2
fi

resolve_path() {
    local key="$1"
    local value
    value=$(jq -r ".subpaths.$key // empty" "$CONFIG_FILE")
    [ -z "$value" ] && value=$(jq -r ".$key // empty" "$CONFIG_FILE")
    local docs_root
    docs_root=$(jq -r '.docs_root // empty' "$CONFIG_FILE")
    local scripts_root
    scripts_root=$(jq -r '.scripts_root // empty' "$CONFIG_FILE")
    value="${value//\{docs_root\}/$docs_root}"
    value="${value//\{scripts_root\}/$scripts_root}"
    value="${value/#\~/$HOME}"
    echo "$value"
}

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
TEAM_DIR=$(resolve_path teammembers)
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
SCRIPT_DIR_RESOLVED=$(resolve_path scripts_root)
if [ -f "$SCRIPT_DIR_RESOLVED/update_team_activity.py" ]; then
    echo "  ✅ update_team_activity.py found"
else
    echo "  ❌ update_team_activity.py not found at $SCRIPT_DIR_RESOLVED"
    exit_code=1
fi

if [ -f "$SCRIPT_DIR_RESOLVED/update_team_prs.py" ]; then
    echo "  ✅ update_team_prs.py found"
else
    echo "  ❌ update_team_prs.py not found at $SCRIPT_DIR_RESOLVED"
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
