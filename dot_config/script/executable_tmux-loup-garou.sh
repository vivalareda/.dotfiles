#!/bin/bash

# Create a new tmux session named "loup-garou"
tmux new-session -d -s loup-garou -n 'nvim-backend' -c ./loup-garou-backend

# Backend window (nvim-backend)
tmux send-keys -t loup-garou:0 'python main.py' C-m

# Frontend window (nvim-frontend)
tmux new-window -t loup-garou:1 -n 'nvim-frontend' -c ./loup-garou-frontend
tmux send-keys -t loup-garou:1 'npm start' C-m

# Server view window (server)
tmux new-window -t loup-garou:2 -n 'server'
tmux split-window -h -t loup-garou:2

# Left pane: Backend server
tmux send-keys -t loup-garou:2.0 'cd loup-garou-backend && python main.py' C-m

# Right pane: Frontend server
tmux send-keys -t loup-garou:2.1 'cd loup-garou-frontend && npm start' C-m

# Select the first window and attach session
tmux select-window -t loup-garou:0
tmux attach-session -t loup-garou
