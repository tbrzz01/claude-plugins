#!/bin/bash
# Find the most recent weekly plan by numeric prefix.
# Reads paths from plugins/weekly-planning/config.local.json (falls back to config.example.json).

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONFIG_FILE="$PLUGIN_ROOT/config.local.json"
[ -f "$CONFIG_FILE" ] || CONFIG_FILE="$PLUGIN_ROOT/config.example.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: no config found at $PLUGIN_ROOT/config.local.json" >&2
    echo "Copy config.example.json to config.local.json and set your paths." >&2
    exit 2
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is required to read config.local.json (brew install jq)" >&2
    exit 2
fi

DOCS_ROOT=$(jq -r '.docs_root' "$CONFIG_FILE")
WEEKLY_PLAN_DIR=$(jq -r '.subpaths.weekly_plans' "$CONFIG_FILE")
WEEKLY_PLAN_DIR="${WEEKLY_PLAN_DIR//\{docs_root\}/$DOCS_ROOT}"
WEEKLY_PLAN_DIR="${WEEKLY_PLAN_DIR/#\~/$HOME}"

latest_file=$(ls "$WEEKLY_PLAN_DIR"/*.md 2>/dev/null | \
    grep -E '/[0-9]{3}-' | \
    sed 's/.*\/\([0-9]*\)-.*/\1 &/' | \
    sort -n | \
    tail -1 | \
    cut -d' ' -f2-)

if [ -z "$latest_file" ]; then
    echo "No weekly plans found in $WEEKLY_PLAN_DIR"
    exit 1
fi

echo "$latest_file"
