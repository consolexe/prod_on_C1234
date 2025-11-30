#!/bin/bash
# simple wrapper to run agent_runner
AI_DIR="$HOME/ai-os"
MODEL="$1"
TASK="$2"
bash "$AI_DIR/core/agent_runner.sh" "$MODEL" "$TASK"
