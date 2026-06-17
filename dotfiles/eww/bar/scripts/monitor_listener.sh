#!/usr/bin/env bash

# Loop to ensure the listener automatically reconnects if the socket closes
while true; do
  socket_path="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
  
  if [ -S "$socket_path" ]; then
    # Listen to Hyprland events and trigger launch_bar.sh when monitors change
    socat -u "UNIX-CONNECT:$socket_path" - | while read -r line; do
      if [[ "$line" == monitoradded>>* || "$line" == monitorremoved>>* ]]; then
        ~/.config/eww/bar/scripts/launch_bar.sh
      fi
    done
  fi
  sleep 2
done
