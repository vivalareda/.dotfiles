#!/usr/bin/env bash

languages=$(echo "typescript rust bash java python bash" | tr " " "\n")
core_utils=$(echo "find xargs sed awk" | tr " " "\n")
selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "GIMME QUERY: " query

if echo $languages | grep -qs $selected; then
  tmux split-window -v bash -c "curl cht.sh/$selected/$(echo "$query" | tr " " "+") | bat --paging=always "
else
  tmux split-window -v bash -c "curl cht.sh/$selected~$query/$(echo "$query" | tr " " "+") | less "
fi

