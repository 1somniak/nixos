#!/usr/bin/env bash

TOTAL_NOTIF=$(swaync-client -c 2>/dev/null || echo 0)
IS_PAUSED=$(swaync-client -D 2>/dev/null || echo "false")

if [ "$IS_PAUSED" = "true" ]; then
  echo '{"icon": "󰂛", "class": "dnd", "count": '$TOTAL_NOTIF'}'
else
  if [ "$TOTAL_NOTIF" -gt 0 ]; then
    echo '{"icon": "󰂟", "class": "has-notif", "count": '$TOTAL_NOTIF'}'
  else
    echo '{"icon": "", "class": "empty", "count": 0}'
  fi
fi
