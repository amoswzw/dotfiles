#!/bin/bash
source "$CONFIG_DIR/colors.sh"

CLASH_SOCKET="/tmp/verge/verge-mihomo.sock"
SECRET=$(grep "^secret:" "$HOME/Library/Application Support/io.github.clash-verge-rev.clash-verge-rev/config.yaml" 2>/dev/null | awk '{print $2}')

if ! pgrep -x "clash-verge" > /dev/null; then
  sketchybar --set "$NAME" icon=󱕻 label="Off" icon.color="$SUBTEXT" label.color="$SUBTEXT"
  exit 0
fi

CONFIGS=$(curl -sf -m 2 --unix-socket "$CLASH_SOCKET" \
  -H "Authorization: Bearer $SECRET" \
  http://localhost/configs 2>/dev/null)

if [ -z "$CONFIGS" ]; then
  sketchybar --set "$NAME" icon=󱕻 label="?" icon.color="$YELLOW"
  exit 0
fi

MODE=$(echo "$CONFIGS" | python3 -c "import sys,json; print(json.load(sys.stdin).get('mode','?'))" 2>/dev/null)

case "$MODE" in
  global) LABEL="Global" ; COLOR=$RED    ;;
  rule)   LABEL="Rule"   ; COLOR=$GREEN  ;;
  direct) LABEL="Direct" ; COLOR=$SUBTEXT ;;
  *)      LABEL="$MODE"  ; COLOR=$YELLOW ;;
esac

sketchybar --set "$NAME" icon=󱕻 label="$LABEL" icon.color="$COLOR" label.color="$TEXT"
