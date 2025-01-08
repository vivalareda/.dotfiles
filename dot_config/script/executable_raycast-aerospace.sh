#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title My Script Command
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

numbers=$(seq 0 9)

# Use fzf for selection
selected_number=$(echo "$numbers" | fzf --prompt="Select a number: ")

# Output the selected number
echo "You selected: $selected_number"
