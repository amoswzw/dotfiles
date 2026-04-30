#!/bin/bash
source "$CONFIG_DIR/colors.sh"

BATT=$(pmset -g batt 2>/dev/null)
PERCENT=$(echo "$BATT" | grep -Eo '[0-9]+%' | tr -d '%')
[ -z "$PERCENT" ] && exit 0

# Order matters: check "discharging" first — "discharging" contains "charging"
if echo "$BATT" | grep -q "discharging"; then
  STATE="discharging"
elif echo "$BATT" | grep -q "not charging"; then
  STATE="plugged"
elif echo "$BATT" | grep -q "finishing charge\|charging"; then
  STATE="charging"
else
  STATE="plugged"
fi

case "$STATE" in
  charging)
    ICON="󰂄"
    COLOR=$GREEN
    ;;
  plugged)
    if   [ "$PERCENT" -le 20 ]; then ICON="󰁻"
    elif [ "$PERCENT" -le 50 ]; then ICON="󰁽"
    elif [ "$PERCENT" -le 80 ]; then ICON="󰁿"
    else                              ICON="󰁹"
    fi
    COLOR=$TEAL
    ;;
  discharging)
    if   [ "$PERCENT" -le 10 ]; then ICON="󰁺" ; COLOR=$RED
    elif [ "$PERCENT" -le 20 ]; then ICON="󰁻" ; COLOR=$RED
    elif [ "$PERCENT" -le 35 ]; then ICON="󰁼" ; COLOR=$YELLOW
    elif [ "$PERCENT" -le 50 ]; then ICON="󰁽" ; COLOR=$YELLOW
    elif [ "$PERCENT" -le 65 ]; then ICON="󰁾" ; COLOR=$TEXT
    elif [ "$PERCENT" -le 80 ]; then ICON="󰁿" ; COLOR=$TEXT
    elif [ "$PERCENT" -le 95 ]; then ICON="󰂀" ; COLOR=$GREEN
    else                              ICON="󰁹" ; COLOR=$GREEN
    fi
    ;;
esac

sketchybar --set "$NAME" icon="$ICON" label="${PERCENT}%" icon.color="$COLOR"
