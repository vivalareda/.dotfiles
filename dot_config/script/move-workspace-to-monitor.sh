#!/bin/bash

current_workspace=$(aerospace list-windows --focused --format "%{workspace}")
sed -i '' -e "/^$current_workspace = / s/\['main'\]/['secondary']/" -e "/^$current_workspace = / s/\['secondary'\]/['main']/" ~/.config/aerospace/aerospace.toml
aerospace reload-config
sketchybar --reload
