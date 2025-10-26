#!/usr/bin/env bash

# Get current session name
current_session=$(tmux display-message -p '#S')

# Start neovim in window 0
tmux send-keys -t "${current_session}:1" "nvim" Enter

# Create new window 1
tmux new-window -t "${current_session}:2" -n "dev-servers"

# Split window 1 vertically
tmux split-window -t "${current_session}:2" -h -p 33

# Split the right pane horizontally
tmux split-window -t "${current_session}:2.2" -v -p 50

# Wait for everything to be ready
sleep 0.3

# Send commands to specific panes in window 1
tmux send-keys -t "${current_session}:2.1" "bin/dev start" Enter
tmux send-keys -t "${current_session}:2.2" "echo 'Monitoring pane ready'" Enter
tmux send-keys -t "${current_session}:2.3" "caddy run" Enter

# Go back to window 0
tmux select-window -t "${current_session}:1"
