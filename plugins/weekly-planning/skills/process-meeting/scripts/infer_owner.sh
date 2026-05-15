#!/bin/bash
# Owner Inference Script
# Helps determine task ownership based on patterns and context

# Usage: ./infer_owner.sh "task description" "meeting context"

TASK="$1"
CONTEXT="$2"

# Define team members and their domains
declare -A TEAM_DOMAINS
TEAM_DOMAINS["trey"]="labs|learning|architecture|strategy|ownership"
TEAM_DOMAINS["jason"]="skills enablement|frontend|gwg|cte"
TEAM_DOMAINS["charles"]="labs|technical skills experiences"
TEAM_DOMAINS["diby"]="labs|technical skills mastery|aws|vocareum"
TEAM_DOMAINS["eyupcan"]="architecture|migration|monolith"

# Check for explicit ownership patterns
if echo "$TASK" | grep -iq "trey will\|trey:\|trey -\|trey should"; then
    echo "Trey Briggs"
    exit 0
fi

if echo "$TASK" | grep -iq "jason will\|jason:\|jason -\|jason should"; then
    echo "Jason Diaz"
    exit 0
fi

if echo "$TASK" | grep -iq "charles will\|charles:\|charles -\|charles should"; then
    echo "Charles Pham"
    exit 0
fi

if echo "$TASK" | grep -iq "diby will\|diby:\|diby -\|diby should\|dibyendu"; then
    echo "Dibyendu Tiwari"
    exit 0
fi

if echo "$TASK" | grep -iq "eyupcan will\|eyupcan:\|eyupcan -\|eyupcan should"; then
    echo "Eyupcan Bodur"
    exit 0
fi

# Check for domain-based ownership
TASK_LOWER=$(echo "$TASK $CONTEXT" | tr '[:upper:]' '[:lower:]')

for person in "${!TEAM_DOMAINS[@]}"; do
    domains="${TEAM_DOMAINS[$person]}"
    if echo "$TASK_LOWER" | grep -Eq "$domains"; then
        case "$person" in
            trey) echo "Trey Briggs"; exit 0 ;;
            jason) echo "Jason Diaz"; exit 0 ;;
            charles) echo "Charles Pham"; exit 0 ;;
            diby) echo "Dibyendu Tiwari"; exit 0 ;;
            eyupcan) echo "Eyupcan Bodur"; exit 0 ;;
        esac
    fi
done

# Default: unassigned
echo "[To be assigned]"
