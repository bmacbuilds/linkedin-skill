#!/usr/bin/env bash
# Removes LinkedIn: only the skill folders our installer marked as ours. Nothing you made with it is ever touched.
set -euo pipefail
MARKER=".linkedin-install"
COMMANDS="post comment reply profile plan cleanup carousel repurpose dm inbox audit"   # written by scripts/sync.py from skill.json
removed=0
for base in linkedin bmac-linkedin; do
  for name in "$base" $(for s in $COMMANDS; do printf '%s-%s ' "$base" "$s"; done); do
    dir="$HOME/.claude/skills/$name"
    [ -e "$dir" ] || continue
    if [ -f "$dir/$MARKER" ]; then
      rm -rf "$dir"; removed=$((removed + 1))
    else
      printf 'Left %s alone: LinkedIn did not install it.\n' "$dir"
    fi
  done
done
if [ "$removed" -gt 0 ]; then printf 'Removed LinkedIn (%s skill folders).\n' "$removed"; else printf 'LinkedIn was not installed.\n'; fi
