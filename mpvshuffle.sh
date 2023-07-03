#!/bin/bash

playlist=""
player=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --player)
      player="$2"
      shift # past argument
      shift # past value
      ;;
    *)
      # assume it is the playlist
      playlist="$1"
      shift
      ;;
  esac
done

if [[ -z "$playlist" ]]; then
  echo "Usage: $0 /path/to/playlist.m3u [--player <player_name>]"
  exit 1
fi

# Check if the specified player is installed or use default players
if [[ -n "$player" ]]; then
  if ! command -v "$player" &> /dev/null; then
    echo "Player '$player' is not installed. Please install the specified player or choose one of the default players."
    exit 1
  fi
else
  # Default player order
  players=("smplayer" "baka-mplayer" "celluloid" "mpv")

  # Find the first installed player
  for p in "${players[@]}"; do
    if command -v "$p" &> /dev/null; then
      player="$p"
      break
    fi
  done

  if [[ -z "$player" ]]; then
    echo "None of the supported players (SMPlayer, Baka MPlayer, Celluloid, MPV) is installed. Please install one of these players and try again."
    exit 1
  fi
fi

# Check if the playlist exists
if [[ ! -f "$playlist" ]]; then
  echo "Playlist '$playlist' does not exist."
  exit 1
fi

# Get the directory of the input playlist
playlist_dir=$(dirname "$playlist")

# Shuffle the playlist and save it as shuffled_playlist.m3u
shuffled_playlist="${playlist_dir}/shuffled_playlist.m3u"
shuf "$playlist" > "$shuffled_playlist"

# Open the specified player with the shuffled playlist
"$player" "$shuffled_playlist"
