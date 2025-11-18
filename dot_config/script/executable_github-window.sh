#!/bin/bash
cd ~/github
selected=$(fd --type d --max-depth 1 | fzf)
if [ -n "$selected" ]; then
  cd "$selected"
fi
exec $SHELL
