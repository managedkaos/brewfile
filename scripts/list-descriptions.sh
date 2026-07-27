#!/usr/bin/env bash
# Parse Brewfile and print packages that have a preceding comment description.
# Output format: PACKAGE_NAME: DESCRIPTION

set -euo pipefail

BREWFILE="${1:-$(dirname "$0")/../Brewfile}"

prev_line=""
while IFS= read -r line; do
  if [[ "$line" =~ ^(brew|cask|vscode|go|npm|krew|uv)\ \"([^\"]+)\" ]]; then
    package="${BASH_REMATCH[2]}"
    if [[ "$prev_line" =~ ^#\ (.+) ]]; then
      echo "$package: ${BASH_REMATCH[1]}"
    fi
  fi
  prev_line="$line"
done < "$BREWFILE"
