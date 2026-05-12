#!/usr/bin/env bash

#MONITORS=$(hyprctl monitors | "grep" Monitor | awk '{print $2}') ; WALLPAPER=$(find /home/louis/.config/hypr/wallpapers/ -name "*essy*" -type f | shuf -n 1) ; for MONITOR in $MONITORS; do hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER" ; done

set -euo pipefail

wallpaper_dir="$HOME/.config/hypr/wallpapers"

pick_random_wallpaper() {
    find -L "$wallpaper_dir" -type f | shuf -n 1
}

# Hyprpaper may not be ready immediately when Hyprland starts.
for _ in $(seq 1 30); do
    if pgrep -x hyprpaper >/dev/null 2>&1; then
        break
    fi
    sleep 0.2
done

if ! pgrep -x hyprpaper >/dev/null 2>&1; then
    echo "hyprpaper n'est pas pret, abandon du script."
    exit 1
fi

set_wallpaper() {
    local wallpaper="$1"

    for _ in $(seq 1 25); do
        if hyprctl hyprpaper wallpaper ",$wallpaper" >/dev/null 2>&1; then
            return 0
        fi
        sleep 0.2
    done

    return 1
}

WALLPAPER=$(pick_random_wallpaper)

if [[ -z "$WALLPAPER" ]]; then
    echo "Aucun fond trouve dans $wallpaper_dir"
    exit 1
fi

echo "Fond sélectionné: $WALLPAPER"

if ! set_wallpaper "$WALLPAPER"; then
    echo "Impossible d'appliquer le fond via hyprpaper"
    exit 1
fi

while sleep 900; do
    WALLPAPER=$(pick_random_wallpaper)

    if [[ -z "$WALLPAPER" ]]; then
        continue
    fi

    echo "Fond sélectionné: $WALLPAPER"
    if ! set_wallpaper "$WALLPAPER"; then
        echo "Echec application fond, nouvelle tentative au cycle suivant"
        continue
    fi
done
