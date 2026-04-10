#!/bin/bash

source_directory=$(find . -type d | fzf)
echo "souce directory $source_directory"

mv "$source_directory"/* "$source_directory"/.[^.]* . 2>/dev/null
rmdir "$source_directory"
