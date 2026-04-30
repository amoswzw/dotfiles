#!/bin/bash
source "$CONFIG_DIR/colors.sh"

CURRENT=$(yabai -m query --spaces --space 2>/dev/null \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['index'])" 2>/dev/null)
INDEX="${NAME##*.}"

if [ "$INDEX" = "$CURRENT" ]; then
  sketchybar --set "$NAME" \
    icon.color="$BASE" \
    background.color="$MAUVE"
else
  sketchybar --set "$NAME" \
    icon.color="$SUBTEXT" \
    background.color="$SURFACE0"
fi
