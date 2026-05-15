#!/bin/bash
# Extract HTML title from a URL
# Usage: ./extract_html_title.sh "https://example.com/page"

URL="$1"

if [ -z "$URL" ]; then
    echo "Usage: $0 URL"
    echo "Example: $0 https://example.com/page"
    exit 1
fi

# Fetch HTML and extract title tag
# Note: This works for simple cases, may need enhancement for complex pages
TITLE=$(curl -sL --max-time 5 "$URL" | \
    sed -n 's/.*<title>\(.*\)<\/title>.*/\1/ip' | \
    head -1 | \
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

# Decode common HTML entities
TITLE=$(echo "$TITLE" | \
    sed 's/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/&quot;/"/g; s/&#39;/'"'"'/g')

if [ -z "$TITLE" ]; then
    # Fallback: try to get title from URL path
    FALLBACK=$(echo "$URL" | sed 's|.*/||; s|\.html$||; s|\?.*||; s|-| |g; s|_| |g')
    echo "Warning: Could not extract title, using fallback" >&2
    echo "$FALLBACK"
    exit 1
fi

echo "$TITLE"
