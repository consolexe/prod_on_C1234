#!/bin/bash
LOG="$1"
TASK="$2"
AI_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
FIXRAW="$AI_DIR/logs/fix_raw.txt"

if [[ -z "$LOG" || -z "$TASK" ]]; then
  echo "Usage: autofix.sh <logfile> <taskfile>"
  exit 1
fi

ERR=$(tail -n 200 "$LOG")

PROMPT="You are an AI DevOps assistant. Fix the failing commands below. Output only commands between ### START and ### END.

ERROR LOG:
$ERR

FAILED COMMANDS:
$(cat "$TASK")

### START
<fixed_commands>
### END
"

ollama run qwen2.5:3b <<< "$PROMPT" > "$FIXRAW" 2>&1 || true
sed -n '/### START/,/### END/p' "$FIXRAW" | sed '1d;$d' > "$TASK"
chmod +x "$TASK"
echo "[AUTOFIX] Rewrote $TASK, re-running executor..."
bash "$AI_DIR/core/executor.sh"
