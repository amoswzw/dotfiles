#!/bin/bash
source "$CONFIG_DIR/colors.sh"

CPU=$(top -l 2 -n 0 | grep "CPU usage" | tail -1 | awk '{print $3}' | tr -d '%')
CPU=${CPU%.*}  # strip decimal
[ -z "$CPU" ] && CPU=0

if   [ "$CPU" -ge 80 ]; then COLOR=$RED
elif [ "$CPU" -ge 50 ]; then COLOR=$YELLOW
else                         COLOR=$PEACH
fi

sketchybar --set "$NAME" label="${CPU}%" icon.color="$COLOR"
