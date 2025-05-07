#!/bin/bash
set -xeuo pipefail

# Change snapserver source to Spotify only if no custom configuration is mounted
if ! [ -e '/config/snapserver.conf' ]; then
  if ! [ -d '/config' ]; then
    mkdir /config
  fi

  cp /etc/snapserver.conf /config/snapserver.conf

  credentials=""
  if [[ -n "${USERNAME:-}" ]] && [[ -n "${PASSWORD:-}" ]]; then
    credentials="\&username=${USERNAME}\&password=${PASSWORD}"
  elif [[ -n "${CACHE:-}" ]]; then
    credentials="\&cache=${CACHE}"
  fi
  sed -i "s,^source = .*,source = librespot:///librespot?name=Spotify\&devicename=${DEVICE_NAME:-Snapcast}\&bitrate=320\&volume=100${credentials}," /config/snapserver.conf
fi

exec snapserver -c /config/snapserver.conf
