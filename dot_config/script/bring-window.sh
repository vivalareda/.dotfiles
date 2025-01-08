#!/bin/bash


current_workspace=$(aerospace list-windows --focused --format "%{workspace}")
select_window_json=$(aerospace list-windows --all --format "%{app-name} %{workspace} %{window-id}" --json)
app_names=$(echo "$select_window_json" | jq -r '.[]."app-name"')
# terminal_window_id=$(echo "$select_window_json" | jq -r '.[] | select(.["app-name"] == "Terminal") | ."window-id"')

# aerospace focus --window_id $terminal_window_id
# echo "$terminal_window_id"
echo "window focused"
window_to_move=$( (echo "$app_names" | fzf) | xargs) 
matching_block=$(echo "$select_window_json" | jq -r --arg app "$window_to_move" '.[] | select(.["app-name"] == $app)')
window_id=$(echo "$matching_block" | jq -r '."window-id"')

aerospace focus --window-id $window_id
aerospace move-node-to-workspace $current_workspace --focus-follows-window
