#!/bin/bash

CACHE_DIR="/tmp/sketchybar_mariners"
mkdir -p "$CACHE_DIR"

SCHEDULE_DATA=$(curl -s "https://statsapi.mlb.com/api/v1/schedule?sportId=1&teamId=136&hydrate=linescore,team")

GAME_STATE=$(echo "$SCHEDULE_DATA" | jq -r '.dates[0].games[0].status.abstractGameState // empty')

if [ -z "$GAME_STATE" ]; then
  sketchybar --set $NAME drawing=off update_freq=300
  exit 0
fi

HOME_TEAM=$(echo "$SCHEDULE_DATA" | jq -r '.dates[0].games[0].teams.home.team.abbreviation')
AWAY_TEAM=$(echo "$SCHEDULE_DATA" | jq -r '.dates[0].games[0].teams.away.team.abbreviation')

if [ "$GAME_STATE" = "Live" ]; then
  sketchybar --set $NAME update_freq=30

  GAME_PK=$(echo "$SCHEDULE_DATA" | jq -r '.dates[0].games[0].gamePk')
  LIVE_DATA=$(curl -s "https://statsapi.mlb.com/api/v1.1/game/${GAME_PK}/feed/live")
  LINESCORE=$(echo "$LIVE_DATA" | jq '.liveData.linescore')

  HOME_SCORE=$(echo "$SCHEDULE_DATA" | jq -r '.dates[0].games[0].teams.home.score')
  AWAY_SCORE=$(echo "$SCHEDULE_DATA" | jq -r '.dates[0].games[0].teams.away.score')
  INNING=$(echo "$LINESCORE" | jq -r '.currentInningOrdinal')
  HALF=$(echo "$LINESCORE" | jq -r '.inningHalf')
  OUTS=$(echo "$LINESCORE" | jq -r '.outs')

  # Top of inning: away team bats. Bottom of inning: home team bats.
  # Brackets wrap the batting team so it's obvious at a glance.
  if [ "$HALF" = "Top" ]; then
    ARROW="▲"
    AWAY_LABEL="[$AWAY_TEAM]"
    HOME_LABEL="$HOME_TEAM"
  else
    ARROW="▼"
    AWAY_LABEL="$AWAY_TEAM"
    HOME_LABEL="[$HOME_TEAM]"
  fi

  # Baserunners: ◆ = occupied, ◇ = empty
  ON_FIRST=$(echo "$LINESCORE" | jq '.offense.first // empty')
  ON_SECOND=$(echo "$LINESCORE" | jq '.offense.second // empty')
  ON_THIRD=$(echo "$LINESCORE" | jq '.offense.third // empty')

  [ -n "$ON_FIRST" ] && B1="◆" || B1="◇"
  [ -n "$ON_SECOND" ] && B2="◆" || B2="◇"
  [ -n "$ON_THIRD" ] && B3="◆" || B3="◇"

  # Outs: ● = out recorded, ○ = available. Reset to 0 at 3 outs (between half-innings)
  if [ "$OUTS" -ge 3 ] 2>/dev/null; then
    OUTS=0
  fi
  OUTS_DISPLAY=""
  for i in 1 2 3; do
    if [ "$OUTS" -ge "$i" ] 2>/dev/null; then
      OUTS_DISPLAY="${OUTS_DISPLAY}●"
    else
      OUTS_DISPLAY="${OUTS_DISPLAY}○"
    fi
  done

  LABEL="$AWAY_LABEL $AWAY_SCORE - $HOME_LABEL $HOME_SCORE ${ARROW}${INNING} ${B3}${B2}${B1} ${OUTS_DISPLAY}"
  sketchybar --set $NAME drawing=on label="$LABEL"

  # Clear final timestamp if game is live
  rm -f "$CACHE_DIR/final_time"

elif [ "$GAME_STATE" = "Final" ]; then
  sketchybar --set $NAME update_freq=60

  # Track when we first saw the final
  if [ ! -f "$CACHE_DIR/final_time" ]; then
    date +%s > "$CACHE_DIR/final_time"
  fi

  FINAL_TIME=$(cat "$CACHE_DIR/final_time")
  NOW=$(date +%s)
  ELAPSED=$(( NOW - FINAL_TIME ))

  # Hide after 30 minutes
  if [ "$ELAPSED" -gt 1800 ]; then
    sketchybar --set $NAME drawing=off update_freq=300
    exit 0
  fi

  HOME_SCORE=$(echo "$SCHEDULE_DATA" | jq -r '.dates[0].games[0].teams.home.score')
  AWAY_SCORE=$(echo "$SCHEDULE_DATA" | jq -r '.dates[0].games[0].teams.away.score')
  LABEL="$AWAY_TEAM $AWAY_SCORE - $HOME_TEAM $HOME_SCORE (F)"
  sketchybar --set $NAME drawing=on label="$LABEL"

elif [ "$GAME_STATE" = "Preview" ]; then
  sketchybar --set $NAME update_freq=300

  GAME_TIME=$(echo "$SCHEDULE_DATA" | jq -r '.dates[0].games[0].gameDate')
  UTC_EPOCH=$(date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$GAME_TIME" "+%s" 2>/dev/null)
  LOCAL_TIME=$(date -j -f "%s" "$UTC_EPOCH" "+%-I:%M %p" 2>/dev/null || echo "$GAME_TIME")
  LABEL="$AWAY_TEAM @ $HOME_TEAM $LOCAL_TIME"
  sketchybar --set $NAME drawing=on label="$LABEL"

  rm -f "$CACHE_DIR/final_time"

else
  sketchybar --set $NAME drawing=off update_freq=300
fi
