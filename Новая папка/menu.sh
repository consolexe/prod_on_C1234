#!/bin/bash
# ai-os-pro menu starter (lightweight)
AI_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CORE="$AI_DIR/core"
MODULES="$AI_DIR/modules"
LOGS="$AI_DIR/logs"
mkdir -p "$CORE" "$MODULES" "$LOGS"

echo "AI-OS PRO - menu"
echo "1) Run generator+executor (interactive)"
echo "2) Run agent (multi-step)"
echo "3) Add cron task (quick)"
read -p "Choose: " CH

if [[ "$CH" == "1" ]]; then
  read -p "Model (example: qwen2.5:3b): " MODEL
  read -p "Describe task: " TASK
  bash "$CORE/generator.sh" "$MODEL" "$TASK"
  bash "$CORE/executor.sh"
  exit 0
fi

if [[ "$CH" == "2" ]]; then
  read -p "Model (example: qwen2.5:3b): " MODEL
  read -p "Describe task: " TASK
  bash "$CORE/agent_runner.sh" "$MODEL" "$TASK"
  exit 0
fi

if [[ "$CH" == "3" ]]; then
  read -p "Cron expression (e.g. 0 8 * * *): " CRON
  read -p "Command to run: " CMD
  read -p "Tag name: " TAG
  sudo bash "$MODULES/ai_cron.sh" add "$CRON" "$CMD" "$TAG"
  exit 0
fi

echo "Bye"
