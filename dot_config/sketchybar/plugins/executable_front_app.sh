#!/bin/sh

refresh_workspace_icons() {
 local workspace apps icon_strip=" "

 workspace=$(aerospace list-workspaces --focused)
 [ -z "$workspace" ] && return

 apps=$(aerospace list-windows --workspace "$workspace" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

 source "$CONFIG_DIR/icon_map.sh"

 if [ -n "$apps" ]; then
   while read -r app; do
     [ -z "$app" ] && continue
     __icon_map "$app"
     icon_strip+=" $icon_result"
   done <<< "$apps"
 else
   icon_strip=" —"
 fi

 sketchybar --set "space.$workspace" label="$icon_strip"
}

if [ "$SENDER" = "front_app_switched" ]; then
 sketchybar --set "$NAME" \
   label="$INFO" \
   icon.background.image="app.$INFO" \
   icon.background.image.scale=0.8

 refresh_workspace_icons
fi
