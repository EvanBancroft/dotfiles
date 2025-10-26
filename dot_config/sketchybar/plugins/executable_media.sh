#!/usr/bin/env bash

# Get Spotify info using AppleScript (works on Sequoia)
get_spotify_info() {
  osascript -e '
    tell application "System Events"
        if (name of processes) contains "Spotify" then
            tell application "Spotify"
                if player state is playing then
                    set track_name to name of current track
                    set artist_name to artist of current track
                    return track_name & " - " & artist_name
                else
                    return ""
                end if
            end tell
        else
            return ""
        end if
    end tell
    ' 2>/dev/null
}

# Get the media info
MEDIA=$(get_spotify_info)

# Debug logging
echo "$(date): Spotify check - Media: '$MEDIA'" >>~/sketchybar-debug.log

if [[ -n "$MEDIA" && "$MEDIA" != "" ]]; then
  echo "$(date): Showing: $MEDIA" >>~/sketchybar-debug.log
  sketchybar --set "$NAME" label="$MEDIA" drawing=on
else
  echo "$(date): Hiding media" >>~/sketchybar-debug.log
  sketchybar --set "$NAME" drawing=off
fi
