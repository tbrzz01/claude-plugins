#!/bin/bash
# Owner Inference Script
# Helps determine task ownership based on patterns and context

# Usage: ./infer_owner.sh "task description" "meeting context"

TASK="$1"
CONTEXT="$2"

# Example team-member to domain mapping. Edit for your team.
declare -A TEAM_DOMAINS
TEAM_DOMAINS["alex"]="labs|learning|architecture|strategy|ownership"
TEAM_DOMAINS["jordan"]="skills enablement|frontend|gwg|cte"
TEAM_DOMAINS["sam"]="labs|technical skills experiences"
TEAM_DOMAINS["riley"]="labs|technical skills mastery|aws|vocareum"
TEAM_DOMAINS["casey"]="architecture|migration|monolith"

# Check for explicit ownership patterns
if echo "$TASK" | grep -iq "alex will\|alex:\|alex -\|alex should"; then
    echo "Alex Chen"
    exit 0
fi

if echo "$TASK" | grep -iq "jordan will\|jordan:\|jordan -\|jordan should"; then
    echo "Jordan Patel"
    exit 0
fi

if echo "$TASK" | grep -iq "sam will\|sam:\|sam -\|sam should"; then
    echo "Sam Lee"
    exit 0
fi

if echo "$TASK" | grep -iq "riley will\|riley:\|riley -\|riley should"; then
    echo "Riley Kim"
    exit 0
fi

if echo "$TASK" | grep -iq "casey will\|casey:\|casey -\|casey should"; then
    echo "Casey Park"
    exit 0
fi

# Check for domain-based ownership
TASK_LOWER=$(echo "$TASK $CONTEXT" | tr '[:upper:]' '[:lower:]')

for person in "${!TEAM_DOMAINS[@]}"; do
    domains="${TEAM_DOMAINS[$person]}"
    if echo "$TASK_LOWER" | grep -Eq "$domains"; then
        case "$person" in
            alex) echo "Alex Chen"; exit 0 ;;
            jordan) echo "Jordan Patel"; exit 0 ;;
            sam) echo "Sam Lee"; exit 0 ;;
            riley) echo "Riley Kim"; exit 0 ;;
            casey) echo "Casey Park"; exit 0 ;;
        esac
    fi
done

# Default: unassigned
echo "[To be assigned]"
