#!/bin/bash

sketchybar --add item tmux.git left \
  --set tmux.git \
  icon.drawing=off \
  script="$PLUGIN_DIR/tmux.git.sh" \
  --add event tmux_session_update \
  --subscribe tmux.attached tmux_session_update
