#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icon_map.sh"

workspace_apps() {
 local workspace="$1"
 [ -z "$workspace" ] && return
 aerospace list-windows --workspace "$workspace" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}'
}

reload_workspace_icon() {
 local workspace="$1"
 local apps icon_strip=" "

 [ -z "$workspace" ] && return

 apps=$(workspace_apps "$workspace")

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

workspace_is_empty() {
 local workspace="$1"
 [ -z "$workspace" ] && return 0
 [ -z "$(workspace_apps "$workspace")" ]
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then
 AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')

 reload_workspace_icon "$AEROSPACE_PREV_WORKSPACE"
 reload_workspace_icon "$AEROSPACE_FOCUSED_WORKSPACE"

 if [ -n "$AEROSPACE_PREV_WORKSPACE" ]; then
   if workspace_is_empty "$AEROSPACE_PREV_WORKSPACE"; then
     sketchybar --set "space.$AEROSPACE_PREV_WORKSPACE" display=0
   else
     sketchybar --set "space.$AEROSPACE_PREV_WORKSPACE" \
       icon.highlight=false \
       label.highlight=false \
       background.border_color=$BACKGROUND_2
   fi
 fi

 [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ] && \
   sketchybar --set "space.$AEROSPACE_FOCUSED_WORKSPACE" \
     display="$AEROSPACE_FOCUSED_MONITOR" \
     icon.highlight=true \
     label.highlight=true \
     background.border_color=$GREY
fi
