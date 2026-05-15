#!/bin/bash
# Extract summary from a markdown document
# Looks for first paragraph, summary section, or first 200 characters
# Usage: ./extract_summary.sh "/path/to/document.md"

FILE="$1"

if [ -z "$FILE" ]; then
    echo "Usage: $0 FILE"
    echo "Example: $0 /path/to/doc.md"
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "Error: File not found: $FILE"
    exit 1
fi

# Try to find an explicit summary section first
SUMMARY=$(sed -n '/^## Summary/,/^##/p' "$FILE" | \
    grep -v '^##' | \
    sed '/^$/d' | \
    head -5)

if [ -n "$SUMMARY" ]; then
    echo "$SUMMARY"
    exit 0
fi

# Try to find an overview section
SUMMARY=$(sed -n '/^## Overview/,/^##/p' "$FILE" | \
    grep -v '^##' | \
    sed '/^$/d' | \
    head -5)

if [ -n "$SUMMARY" ]; then
    echo "$SUMMARY"
    exit 0
fi

# Try to find an about section
SUMMARY=$(sed -n '/^## About/,/^##/p' "$FILE" | \
    grep -v '^##' | \
    sed '/^$/d' | \
    head -5)

if [ -n "$SUMMARY" ]; then
    echo "$SUMMARY"
    exit 0
fi

# Fallback: Get first non-empty paragraph after title
# Skip YAML frontmatter if present
SUMMARY=$(sed -n '/^---$/,/^---$/d; /^# /d; /^## /d; /^$/d; p' "$FILE" | \
    head -3)

if [ -n "$SUMMARY" ]; then
    echo "$SUMMARY"
    exit 0
fi

# Last resort: First 200 characters of content
SUMMARY=$(sed -n '/^---$/,/^---$/d; /^# /d; p' "$FILE" | \
    tr -d '\n' | \
    cut -c1-200)

if [ -n "$SUMMARY" ]; then
    echo "${SUMMARY}..."
else
    echo "No summary available"
fi
