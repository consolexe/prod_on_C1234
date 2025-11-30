#!/bin/bash
DB="$HOME/ai-os/memory_simple.txt"
mkdir -p "$(dirname "$DB")"
echo "[$(date)] $*" >> "$DB"
echo "OK"
