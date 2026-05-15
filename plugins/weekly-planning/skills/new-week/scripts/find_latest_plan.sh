#!/bin/bash
# Find the most recent weekly plan by numeric prefix
# Usage: ./find_latest_plan.sh

WEEKLY_PLAN_DIR="/Users/trey.briggs/Code/documentation/work/udemy/Weekly Plan"

# Find all markdown files, extract numeric prefix, sort numerically
latest_file=$(ls "$WEEKLY_PLAN_DIR"/*.md 2>/dev/null | \
    grep -E '/[0-9]{3}-' | \
    sed 's/.*\/\([0-9]*\)-.*/\1 &/' | \
    sort -n | \
    tail -1 | \
    cut -d' ' -f2-)

if [ -z "$latest_file" ]; then
    echo "No weekly plans found"
    exit 1
fi

echo "$latest_file"
