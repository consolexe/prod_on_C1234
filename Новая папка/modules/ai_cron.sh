#!/bin/bash
ACTION="$1"
case "$ACTION" in
  add)
    SCHEDULE="$2"
    CMD="$3"
    TAG="$4"
    CRONF="/etc/cron.d/ai_${TAG}"
    echo "$CMD" > "$CRONF"
    chmod 644 "$CRONF"
    echo "Added cron $CRONF"
    ;;
  list)
    crontab -l || true
    ;;
  remove)
    TAG="$2"
    sudo rm -f "/etc/cron.d/ai_${TAG}"
    echo "Removed $TAG"
    ;;
  *)
    echo "Usage: ai_cron.sh {add|list|remove} ..."
    ;;
esac
