#!/bin/bash
AI_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
TASK="$AI_DIR/task.sh"
LOGS="$AI_DIR/logs"
RESULT="$LOGS/result_$(date +%Y-%m-%d_%H-%M-%S).txt"

if [[ ! -f "$TASK" ]]; then
  echo "[ERROR] No task found at $TASK"
  exit 1
fi

echo "[EXECUTOR] Running $TASK"
bash "$TASK" > "$RESULT" 2>&1
RC=$?
echo "[EXECUTOR] Return code: $RC, log: $RESULT"

if [[ $RC -ne 0 ]]; then
  echo "[EXECUTOR] Error detected, invoking autofix"
  bash "$AI_DIR/core/autofix.sh" "$RESULT" "$TASK"
else
  echo "[EXECUTOR] Success"
fi
