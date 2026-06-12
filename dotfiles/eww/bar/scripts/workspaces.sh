#!/usr/bin/env bash

if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
  HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /run/user/$(id -u)/hypr/ | head -1)
fi

generate() {
  ACTIVE=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id' 2>/dev/null)
  ACTIVE=${ACTIVE:-0}

  OCCUPIED=$(hyprctl workspaces -j | jq -r '.[] | select(.windows > 0) | .id' 2>/dev/null | tr '\n' ' ')

  # Always show 1, 2, 3, the active workspace, and any occupied workspace
  IDS="1 2 3 $ACTIVE $OCCUPIED"
  SORTED_IDS=$(echo "$IDS" | tr ' ' '\n' | sort -n -u | grep -E '^[0-9]+$')

  # Find the 0-based index of the active workspace in the sorted list of displayed workspaces
  read -r -a id_arr <<< "$(echo "$SORTED_IDS" | tr '\n' ' ')"
  ACTIVE_INDEX=0
  for idx in "${!id_arr[@]}"; do
    if [ "${id_arr[$idx]}" -eq "$ACTIVE" ]; then
      ACTIVE_INDEX=$idx
      break
    fi
  done

  echo -n "{\"active_index\": $ACTIVE_INDEX, \"workspaces\": ["
  FIRST=true
  for i in $SORTED_IDS; do
    if [ "$FIRST" = true ]; then
      FIRST=false
    else
      echo -n ','
    fi
    if [ "$i" -eq "$ACTIVE" ]; then
      STATE="active"
    elif [[ " $OCCUPIED " =~ " $i " ]]; then
      STATE="occupied"
    else
      STATE="empty"
    fi
    echo -n "{\"id\": $i, \"state\": \"$STATE\"}"
  done
  echo ']}'
}

generate

SOCKET_PATH="/run/user/$(id -u)/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

if [ -S "$SOCKET_PATH" ]; then
  socat -u UNIX-CONNECT:"$SOCKET_PATH" - | while read -r line; do
    case ${line%>>*} in
    workspace | focusedmon | destroyworkspace | createworkspace | urgent)
      generate
      ;;
    esac
  done
else
  echo "Error: Bos, socket Hyprland ga ketemu" >&2
fi
