#!/usr/bin/env bash

# Script pour cycler entre les dispositifs de sortie audio
# Compatible avec PulseAudio et PipeWire

# Déterminer si on utilise PulseAudio ou PipeWire
if command -v wpctl &> /dev/null; then
    # PipeWire avec WirePlumber
    
    # Obtenir le sink actuel
    current_sink=$(wpctl status | grep -A 10 "Audio" | grep "^\s*\*" | grep -oP "(?<=\. ).*")
    
    # Obtenir tous les sinks disponibles
    mapfile -t sinks < <(wpctl status | grep -A 10 "Sinks:" | grep "^\s*[│├└]" | grep -v "^\s*\*" | sed 's/^[│├└ ]*//' | sed 's/\. /\n/' | sed 's/\[.*\]//')
    
    # Obtenir l'ID du sink actuel
    current_id=$(wpctl status | grep -A 10 "Sinks:" | grep "^\s*\*" | grep -oP "^\s*\*?\s*\K[0-9]+")
    
    # Obtenir tous les IDs de sinks
    mapfile -t sink_ids < <(wpctl status | grep -A 10 "Sinks:" | grep "^\s*[│├└*]" | grep -oP "^\s*\*?\s*[│├└ ]*\K[0-9]+")
    
    # Trouver l'index du sink actuel
    for i in "${!sink_ids[@]}"; do
        if [[ "${sink_ids[$i]}" == "$current_id" ]]; then
            current_index=$i
            break
        fi
    done
    
    # Passer au sink suivant (cycle)
    next_index=$(( (current_index + 1) % ${#sink_ids[@]} ))
    next_sink_id="${sink_ids[$next_index]}"
    
    # Changer le sink par défaut
    wpctl set-default "$next_sink_id"
    
    # Déplacer tous les streams audio vers le nouveau sink
    mapfile -t streams < <(wpctl status | grep -A 20 "Streams:" | grep "^\s*[│├└]" | grep -oP "^\s*[│├└ ]*\K[0-9]+")
    for stream in "${streams[@]}"; do
        wpctl set-default "$next_sink_id" 2>/dev/null
    done
    
    # Obtenir le nom du nouveau sink pour la notification
    new_sink_name=$(wpctl status | grep -A 10 "Sinks:" | grep "^\s*\*" | sed 's/^[│├└ ]*//' | sed 's/^[0-9]*\. //' | sed 's/\[.*\]//')
    
    # Notification
    if command -v notify-send &> /dev/null; then
        notify-send "Audio Output" "Switched to: $new_sink_name" -t 2000
    fi
    
elif command -v pactl &> /dev/null; then
    # PulseAudio
    
    # Obtenir le sink actuel
    current_sink=$(pactl get-default-sink)
    
    # Obtenir tous les sinks disponibles
    mapfile -t sinks < <(pactl list short sinks | cut -f2)
    
    # Trouver l'index du sink actuel
    for i in "${!sinks[@]}"; do
        if [[ "${sinks[$i]}" == "$current_sink" ]]; then
            current_index=$i
            break
        fi
    done
    
    # Passer au sink suivant (cycle)
    next_index=$(( (current_index + 1) % ${#sinks[@]} ))
    next_sink="${sinks[$next_index]}"
    
    # Changer le sink par défaut
    pactl set-default-sink "$next_sink"
    
    # Déplacer tous les streams audio vers le nouveau sink
    pactl list short sink-inputs | while read -r stream; do
        stream_id=$(echo "$stream" | cut -f1)
        pactl move-sink-input "$stream_id" "$next_sink" 2>/dev/null
    done
    
    # Obtenir le nom descriptif pour la notification
    new_sink_desc=$(pactl list sinks | grep -A 10 "Name: $next_sink" | grep "Description:" | cut -d: -f2- | xargs)
    
    # Notification
    if command -v notify-send &> /dev/null; then
        notify-send "Audio Output" "Switched to: $new_sink_desc" -t 2000
    fi
else
    echo "Ni wpctl (PipeWire) ni pactl (PulseAudio) n'est disponible"
    exit 1
fi
