#!/bin/bash
DB="$HOME/ai-os/memory_simple.txt"
QUERY="$*"
if [[ ! -f "$DB" ]]; then
  exit 0
fi
grep -i --line-number -m 10 "$QUERY" "$DB" || true
