#!/bin/bash

current_workspace=$(aerospace list-windows --focused --format "%{workspace}")
target_workspace=$1

aerospace move-node-to-workspace $target_workspace --focus-follows-window
aerospace focus left --ignore-floating --boundaries-action wrap-around-the-workspace
aerospace move-node-to-workspace $current_workspace --focus-follows-window
