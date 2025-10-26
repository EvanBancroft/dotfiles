#!/bin/bash

sketchybar --add item media right \
            --set media label.max_chars=60 \
            icon.padding_left=0 \
            scroll_texts=on \
            background.drawing=off \
            script="$PLUGIN_DIR/media.sh" \
            update_freq=1 \
            icon=
