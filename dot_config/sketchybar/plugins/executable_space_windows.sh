#!/usr/bin/env bash

# On workspace change: refresh the app-icon labels of the previous and the
# focused workspace, hide the previous one if it became empty, and move the
# highlight to the focused one. All updates go out in a single sketchybar call.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icon_map.sh"

# Prints the app names of every window in a workspace, one per line.
workspace_apps() {
 aerospace list-windows --workspace "$1" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}'
}

# Sets $icon_strip to the icon label for a newline-separated list of app names
# (written to a variable instead of echoed, to avoid a subshell per call).
build_icon_strip() {
 local apps="$1"
 icon_strip=" "

 if [ -z "$apps" ]; then
   icon_strip=" —"
   return
 fi

 while read -r app; do
   [ -z "$app" ] && continue
   __icon_map "$app"
   icon_strip+=" $icon_result"
 done <<< "$apps"
}

[ "$SENDER" = "aerospace_workspace_change" ] || exit 0

prev="$AEROSPACE_PREV_WORKSPACE"
focused="$AEROSPACE_FOCUSED_WORKSPACE"
args=()

if [ -n "$prev" ]; then
 prev_apps=$(workspace_apps "$prev")
 build_icon_strip "$prev_apps"
 args+=(--set "space.$prev" label="$icon_strip")

 if [ -z "$prev_apps" ]; then
   args+=(display=0)
 else
   args+=(icon.highlight=false label.highlight=false background.border_color=$BACKGROUND_2)
 fi
fi

if [ -n "$focused" ]; then
 monitor=$(aerospace list-monitors --focused --format "%{monitor-appkit-nsscreen-screens-id}")
 build_icon_strip "$(workspace_apps "$focused")"
 args+=(--set "space.$focused" label="$icon_strip" display="$monitor"
        icon.highlight=true label.highlight=true background.border_color=$GREY)
fi

[ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"
