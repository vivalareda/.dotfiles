#!/usr/bin/env bash

SERVER=192.168.1.149
USERNAME=reda

REMOTE="$USERNAME@$SERVER"

read -p "Branch name: " BRANCH_NAME
read -p "Prompt for agent: " PROMPT

CURRENT_DIR=$(pwd)
PROJECT=${CURRENT_DIR##*/}

echo "Syncing $PROJECT to $REMOTE..."
rsync -avz --exclude 'node_modules' --include '.git' . "$REMOTE:~/projects/$PROJECT/"

echo "Running on server..."
ssh -t "$REMOTE" << EOF
  source ~/.bashrc
  cd ~/projects/$PROJECT
  
  mkdir -p ~/projects/worktrees/$PROJECT
  WORKTREE_PATH=~/projects/worktrees/$PROJECT/${BRANCH_NAME// /-}
  
  git worktree add "\$WORKTREE_PATH"
  cd "\$WORKTREE_PATH"
  
  ni install
  ralphy --init
  echo 'pm2 start --name "${BRANCH_NAME}" ralphy -- --opencode "${PROMPT}"'
  # pm2 logs "${BRANCH_NAME}"
EOF
