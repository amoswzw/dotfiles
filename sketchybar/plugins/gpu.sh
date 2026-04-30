#!/bin/bash
source "$CONFIG_DIR/colors.sh"

DATA=$(ioreg -r -d 1 -c "AGXAccelerator" 2>/dev/null | grep "PerformanceStatistics" | head -1)
GPU=$(echo "$DATA" | grep -o '"Device Utilization %"=[0-9]*' | grep -o '[0-9]*$')
[ -z "$GPU" ] && GPU=0

if   [ "$GPU" -ge 80 ]; then COLOR=$RED
elif [ "$GPU" -ge 50 ]; then COLOR=$YELLOW
else                         COLOR=$MAUVE
fi

sketchybar --set "$NAME" label="${GPU}%" icon.color="$COLOR"
