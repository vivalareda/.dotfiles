#!/bin/bash

first_file=$(ls -t ~/Documents/Screenshots/ | head -n 1)
echo "$first_file"

if [ -z "$first_file" ]; then
  echo "No file found"
  exit 1
fi

file_path=~/Documents/Screenshots/"$first_file"

if command -v pbcopy &> /dev/null; then
  osascript -e "set the clipboard to (read (POSIX file \"$file_path\") as TIFF picture)"
else
    echo "No clipboard tool found"
    exit 1
fi
