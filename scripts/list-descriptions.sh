#!/usr/bin/env bash
# Parse Brewfile and print packages that have a preceding comment description.
# Output is sorted and column-aligned.

set -euo pipefail

BREWFILE="${1:-$(dirname "$0")/../Brewfile}"

declare -a entries=()
max_len=0

prev_line=""
while IFS= read -r line; do
  if [[ "$line" =~ ^(brew|cask|vscode|go|npm|krew|uv)\ \"([^\"]+)\" ]]; then
    package="${BASH_REMATCH[2]}"
    if [[ "$prev_line" =~ ^#\ (.+) ]]; then
      entries+=("$package|${BASH_REMATCH[1]}")
      (( ${#package} > max_len )) && max_len=${#package}
    fi
  fi
  prev_line="$line"
done < "$BREWFILE"

IFS=$'\n' sorted=($(printf '%s\n' "${entries[@]}" | sort -f))
unset IFS

for entry in "${sorted[@]}"; do
  package="${entry%%|*}"
  desc="${entry#*|}"
  printf "%-${max_len}s  %s\n" "$package" "$desc"
done
