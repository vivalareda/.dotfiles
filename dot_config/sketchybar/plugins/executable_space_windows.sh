#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icon_map.sh"

reload_workspace_icon() {
 local workspace="$1"
 local apps icon_strip=" "

 [ -z "$workspace" ] && return

 apps=$(aerospace list-windows --workspace "$workspace" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

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

if [ "$SENDER" = "aerospace_workspace_change" ]; then
 AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
 AEROSPACE_WORKSPACES_FOCUSED_MONITOR=$(aerospace list-workspaces --monitor focused --empty no)
 AEROSPACE_EMPTY_WORKSPACES=$(aerospace list-workspaces --monitor focused --empty)

 reload_workspace_icon "$AEROSPACE_PREV_WORKSPACE"
 reload_workspace_icon "$AEROSPACE_FOCUSED_WORKSPACE"

 [ -n "$AEROSPACE_PREV_WORKSPACE" ] && \
   sketchybar --set "space.$AEROSPACE_PREV_WORKSPACE" \
     icon.highlight=false \
     label.highlight=false \
     background.border_color=$BACKGROUND_2

 [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ] && \
   sketchybar --set "space.$AEROSPACE_FOCUSED_WORKSPACE" \
     icon.highlight=true \
     label.highlight=true \
     background.border_color=$GREY \
     display="$AEROSPACE_FOCUSED_MONITOR"

 for i in $AEROSPACE_WORKSPACES_FOCUSED_MONITOR; do
   sketchybar --set "space.$i" display="$AEROSPACE_FOCUSED_MONITOR"
 done

 for i in $AEROSPACE_EMPTY_WORKSPACES; do
   sketchybar --set "space.$i" display=0
 done
fi

