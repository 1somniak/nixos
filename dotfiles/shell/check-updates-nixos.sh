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
        notify-send "NixOS updates availables :" "$count updated inputs: $list"
    fi
fi
