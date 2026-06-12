#!/usr/bin/env bash
case "$1" in
status)
  swaync-client -D
  ;;
toggle)
  swaync-client -d
  ;;
esac
