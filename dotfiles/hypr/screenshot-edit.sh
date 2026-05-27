#!/usr/bin/env sh
set -e

TMPFILE=$(mktemp /tmp/screenshot-XXXX.png)
# capture selection
if ! grim -g "$(slurp)" "$TMPFILE"; then
  rm -f "$TMPFILE"
  exit 1
fi

# open swappy to annotate
swappy -f "$TMPFILE"

# ensure Pictures exists and save annotated result
DEST_DIR="/tmp/Pictures"
mkdir -p "$DEST_DIR"
NAME="screenshot-$(date +%Y%m%d-%H%M%S).png"
cp "$TMPFILE" "$DEST_DIR/$NAME"

# copy to clipboard
wl-copy < "$TMPFILE" || true

# notify user
if command -v dunstify >/dev/null 2>&1; then
  dunstify "Screenshot saved" "$DEST_DIR/$NAME"
fi

rm -f "$TMPFILE"
