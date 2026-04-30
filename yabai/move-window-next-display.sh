#!/bin/sh

current_display="$(yabai -m query --windows --window 2>/dev/null | jq -r '.display // empty')"
[ -n "$current_display" ] || exit 0

displays_json="$(yabai -m query --displays)"
spaces_json="$(yabai -m query --spaces)"

target_display="$(
  jq -nr \
    --argjson current "$current_display" \
    --argjson displays "$displays_json" \
    --argjson spaces "$spaces_json" '
    ($displays | map(.index) | sort) as $indices
    | (($indices | map(select(. > $current))) + ($indices | map(select(. < $current))))
    | map(select(. as $display |
        [ $spaces[]
          | select(.display == $display and ."is-visible" and ."is-native-fullscreen")
        ] | length == 0
      ))
    | .[0] // empty
  '
)"

[ -n "$target_display" ] || exit 1

yabai -m window --display "$target_display"
yabai -m display --focus "$target_display"
