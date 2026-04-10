#!/usr/bin/env bash

if ! command -v 'ralphy' > /dev/null 2>&1
then 
  echo "ralphy not installed"
  exit 1
fi

if [[ -z "$WORKTREE_DIR" ]]; then
  echo "WORKTREE_DIR is not set"
  exit 1
fi

read -p "Branch name: " BRANCH_NAME 
echo "$BRANCH_NAME"

read -p "Prompt for agent: " PROMPT

CURRENT_DIR=$(pwd)
PROJECT=${CURRENT_DIR##*/}
WORKTREE_PATH="$WORKTREE_DIR/$PROJECT/${BRANCH_NAME// /-}"

echo $WORKTREE_PATH

git worktree add $WORKTREE_PATH

ralphy --init
echo "would run ralphy --opencode $PROMPT"
