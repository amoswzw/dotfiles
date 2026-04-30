#!/bin/bash

# Use nowplaying-cli to query whatever is currently playing (QQMusic, Spotify, Music.app, etc.)
# Returns empty fields when nothing is playing or no supported app is active
INFO=$(nowplaying-cli get --json title artist 2>/dev/null)
TITLE=$(echo "$INFO" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('title') or '')" 2>/dev/null)
ARTIST=$(echo "$INFO" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('artist') or '')" 2>/dev/null)

if [ -n "$TITLE" ]; then
  LABEL="$ARTIST - $TITLE"
  # Truncate if too long
  if [ ${#LABEL} -gt 40 ]; then
    LABEL="${LABEL:0:40}…"
  fi
  sketchybar --set "$NAME" label="$LABEL" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
