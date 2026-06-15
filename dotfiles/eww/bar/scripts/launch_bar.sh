#!/usr/bin/env bash

# Close any running eww bar instances
active_bars=$(eww active-windows 2>/dev/null | grep "window_bar" | cut -d':' -f1)
for bar in $active_bars; do
  eww close "$bar" || true
done
eww close window_bar || true

# Start the eww daemon if it is not already running
eww daemon || true

# Get IDs of all connected monitors and launch an eww bar for each
for mon in $(hyprctl monitors -j | jq -r '.[] | .id'); do
  eww open window_bar --screen "$mon" --id "bar-$mon"
done
