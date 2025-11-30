#!/bin/bash
MODEL="$1"
USER_REQUEST="$2"
AI_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
PROMPT_FILE="$AI_DIR/core/prompt_system.txt"
OUTPUT_RAW="$AI_DIR/logs/raw_output.txt"
TASK_FILE="$AI_DIR/task.sh"

if [[ -z "$MODEL" || -z "$USER_REQUEST" ]]; then
  echo "Usage: generator.sh <model> <request>"
  exit 1
fi

if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "[ERROR] Missing prompt system: $PROMPT_FILE"
  exit 1
fi

PROMPT="$(cat "$PROMPT_FILE")

TASK: $USER_REQUEST

### START
<commands>
### END
"

# generate via ollama (must be installed)
ollama run "$MODEL" <<< "$PROMPT" > "$OUTPUT_RAW" 2>&1 || true

sed -n '/### START/,/### END/p' "$OUTPUT_RAW" | sed '1d;$d' > "$TASK_FILE"
chmod +x "$TASK_FILE"
echo "[OK] Commands saved to $TASK_FILE"
