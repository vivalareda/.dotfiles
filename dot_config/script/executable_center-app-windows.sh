#!/usr/bin/env bash

app_name="$1"

osascript <<EOF
delay 0.35

tell application "$app_name" to activate

tell application "Finder"
  set screenBounds to bounds of window of desktop
  set sw to item 3 of screenBounds
  set sh to item 4 of screenBounds
end tell

tell application "System Events"
  tell application process "$app_name"
    if (count of windows) is 0 then return

    set frontWindow to front window
    set {xPos, yPos} to position of frontWindow
    set {w, h} to size of frontWindow

    set newX to round ((sw - w) / 2)
    set newY to round ((sh - h) / 2)

    set position of frontWindow to {newX, newY}
  end tell
end tell
EOF
