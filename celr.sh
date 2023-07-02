#!/bin/bash

playlist="$1"

if [[ -z "$playlist" ]]; then
  echo "Usage: $0 /path/to/playlist.m3u"
  exit 1
fi

# Check if Celluloid is installed
if ! command -v celluloid &> /dev/null; then
  echo "Celluloid is not installed. Please install Celluloid and try again."
  exit 1
fi

# Shuffle the playlist
shuffled_playlist="/tmp/shuffled_playlist.m3u"
sort -R "$playlist" > "$shuffled_playlist"

# Open Celluloid with the shuffled playlist
celluloid "$shuffled_playlist"
