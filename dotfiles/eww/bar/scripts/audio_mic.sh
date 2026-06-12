#!/usr/bin/env bash

get_status() {
  audio_output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
  if echo "$audio_output" | grep -q "MUTED"; then
    audio="muted"
  else
    audio="unmuted"
  fi
  audio_vol=$(echo "$audio_output" | awk '{print int($2 * 100)}')

  mic_output=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
  if echo "$mic_output" | grep -q "MUTED"; then
    mic="muted"
  else
    mic="unmuted"
  fi
  mic_vol=$(echo "$mic_output" | awk '{print int($2 * 100)}')

  printf '{"audio": "%s", "audio_vol": "%s", "mic": "%s", "mic_vol": "%s"}\n' "$audio" "$audio_vol" "$mic" "$mic_vol"
}

get_status

pactl subscribe | stdbuf -oL grep --line-buffered "change" | while read -r _; do
  get_status
done
