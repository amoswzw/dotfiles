#!/bin/bash
source "$CONFIG_DIR/colors.sh"

IP=$(/sbin/ifconfig en0 2>/dev/null | awk '/inet /{print $2; exit}')

if [ -z "$IP" ]; then
  sketchybar --set "$NAME" icon="󰤭" label="Off" icon.color="$SUBTEXT" label.color="$SUBTEXT"
else
  sketchybar --set "$NAME" icon="󰤨" label="$IP" icon.color="$TEAL" label.color="$TEXT"
fi
