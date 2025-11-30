#!/bin/bash
AI_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
MODEL="${1:-qwen2.5:3b}"
USER_REQUEST="$2"
LOGS="$AI_DIR/logs"
if [[ -z "$USER_REQUEST" ]]; then
  read -p "Enter task: " USER_REQUEST
fi
echo "[AGENT] Generating plan for: $USER_REQUEST"
PROMPT="You are an agent. Produce a numbered plan. For each step output commands in a block between ### START and ### END. Goal: $USER_REQUEST"
ollama run "$MODEL" <<< "$PROMPT" > "$LOGS/agent_plan.txt" 2>&1 || true
# extract all blocks
sed -n '/### START/,/### END/p' "$LOGS/agent_plan.txt" > "$LOGS/agent_steps.txt"
# split by blocks and run sequentially (manual confirmation)
awk '/### START/{flag=1;next}/### END/{flag=0;print "--BLOCK-END--";next}flag{print}' "$LOGS/agent_steps.txt" > "$LOGS/agent_steps_clean.txt"
STEP=0
while IFS= read -r line; do
  if [[ "$line" == "--BLOCK-END--" ]]; then
    STEP=$((STEP+1))
    echo "=== Executing step $STEP ==="
    # run last accumulated block
    echo "$BLOCK" > "$AI_DIR/task.sh"
    chmod +x "$AI_DIR/task.sh"
    echo "Commands:\n$BLOCK"
    read -p "Press Enter to run this step (or 's' to skip): " opt
    if [[ "$opt" != "s" ]]; then
      bash "$AI_DIR/task.sh" > "$LOGS/agent_step_${STEP}.log" 2>&1
      RC=$?
      if [[ $RC -ne 0 ]]; then
        echo "Step $STEP failed, handing to autofix..."
        bash "$AI_DIR/core/autofix.sh" "$LOGS/agent_step_${STEP}.log" "$AI_DIR/task.sh"
      fi
    fi
    BLOCK=""
  else
    BLOCK+="$line\n"
  fi
done < "$LOGS/agent_steps_clean.txt"
echo "[AGENT] Finished."
