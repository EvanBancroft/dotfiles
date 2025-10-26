#!/bin/bash

sketchybar --add item tmux.attached left \
  --set tmux.attached \
  icon.drawing=off \
  script="$PLUGIN_DIR/tmux.attached.sh" \
  --add event tmux_session_update \
  --subscribe tmux.attached tmux_session_update
