#!/bin/bash

sketchybar --add item mariners right \
           --set mariners icon= \
             background.drawing=off \
             script="$PLUGIN_DIR/mariners.sh" \
             update_freq=30 \
             drawing=off
