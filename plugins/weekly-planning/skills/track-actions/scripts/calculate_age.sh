#!/bin/bash
# Calculate age of a task given its first appearance date
# Usage: ./calculate_age.sh "Jan 20, 2026"

if [ $# -eq 0 ]; then
    echo "Usage: $0 'Month Day, Year'"
    exit 1
fi

task_date="$1"

# Convert to a format that date can parse
# macOS date command usage
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    task_epoch=$(date -j -f "%b %d, %Y" "$task_date" "+%s" 2>/dev/null)
    current_epoch=$(date "+%s")
else
    # Linux
    task_epoch=$(date -d "$task_date" "+%s" 2>/dev/null)
    current_epoch=$(date "+%s")
fi

if [ -z "$task_epoch" ]; then
    echo "Error: Could not parse date '$task_date'"
    exit 1
fi

# Calculate difference in seconds
diff_seconds=$((current_epoch - task_epoch))

# Convert to days
diff_days=$((diff_seconds / 86400))

# Convert to weeks
diff_weeks=$((diff_days / 7))

# Output appropriate format
if [ $diff_days -lt 7 ]; then
    if [ $diff_days -eq 1 ]; then
        echo "1 day old"
    else
        echo "$diff_days days old"
    fi
elif [ $diff_weeks -eq 1 ]; then
    echo "1 week old"
else
    echo "$diff_weeks weeks old"
fi
