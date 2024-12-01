#!/bin/sh

volume_icon=(
  click_script="$PLUGIN_DIR/volume_click.sh"
  padding_left=10
  icon=$VOLUME_100
  icon.width=0
  icon.align=left
  icon.padding_right=5
  icon.color=$MAGENTA
  icon.font="$FONT:Regular:14.0"
  label.width=25
  label.font="$FONT:Regular:14.0"
)

status_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add item volume right \
           --set volume script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change \

