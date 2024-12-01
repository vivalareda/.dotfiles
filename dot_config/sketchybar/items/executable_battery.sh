#!/bin/sh

sketchybar --add item battery right \
           --set battery "${battery[@]}"\
              icon.font.size=15 update_freq=120 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery power_source_change system_woke

