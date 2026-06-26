#!/usr/bin/env bash

FLAKE="/etc/nixos"
TMPDIR=$(mktemp -d)

wait_for_internet() {
    until ping -c1 -W1 1.1.1.1 >/dev/null 2>&1 && getent hosts cache.nixos.org >/dev/null 2>&1; do
        sleep 5
    done
}

cp "$FLAKE/flake.lock" "$TMPDIR/flake.lock"
wait_for_internet
output=$(nix flake update --flake "$FLAKE" 2>&1)

cp "$TMPDIR/flake.lock" "$FLAKE/flake.lock"
rm -rf "$TMPDIR"

inputs=$(echo "$output" | grep "Updated input" | sed -E "s/.*Updated input '([^']+)'.*/\1/" | sort -u)

count=$(echo "$inputs" | sed '/^$/d' | wc -l)

if [ "$count" -gt 0 ]; then
    list=$(echo "$inputs" | paste -sd ", " -)
    if command -v notify-send >/dev/null 2>&1; then
        ACTION=$(notify-send "NixOS updates availables :" "$count updated inputs: $list" --action="update=Update Nix Flake")
        if [ "$ACTION" = "update" ]; then
            notify-send "NixOS Update" "Starting system update..." -i system-software-update
            cd /etc/nixos
            nix flake update
            output=$(sudo /run/current-system/sw/bin/systemd-run \
                --property=CPUQuota=200% \
                --property=MemoryMax=2G \
                /run/current-system/sw/bin/nixos-rebuild switch --flake /etc/nixos 2>&1)
            
            unit=$(echo "$output" | sed -n 's/.*Running as unit: \([^ ;]*\).*/\1/p')
            
            if [ -n "$unit" ]; then
                while true; do
                    state=$(systemctl show -p ActiveState --value "$unit")
                    if [ "$state" != "active" ] && [ "$state" != "activating" ]; then
                        break
                    fi
                    sleep 3
                done
                
                result=$(systemctl show -p Result --value "$unit")
                if [ "$result" = "success" ]; then
                    notify-send "NixOS Update" "System update completed successfully!" -i system-software-update
                else
                    notify-send "NixOS Update" "System update failed! (Result: $result)" -u critical -i software-update-urgent
                fi
            else
                notify-send "NixOS Update" "Failed to start systemd-run unit!" -u critical -i software-update-urgent
            fi
        fi
    fi
fi
