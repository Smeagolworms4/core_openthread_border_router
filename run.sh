#!/bin/sh
set -eu

echo "Create virtual device network"

OPT="/data/options.json"
TTY="/tmp/ttyOTBR"   # même chemin que l'addon attend

NET="$(jq -r '.network_device // empty' "$OPT")"
if [ -z "$NET" ]; then
  echo "ERROR: network_device is missing (expected IP:PORT)" >&2
  exit 1
fi

HOST="${NET%:*}"
PORT="${NET#*:}"

rm -f "$TTY"
socat -d -d pty,raw,echo=0,link="$TTY" tcp:"$HOST":"$PORT" >/tmp/socat.log 2>&1 &
sleep 1

tmp="$(mktemp)"
jq --arg dev "$TTY" '. + {device: $dev} | del(.network_device)' "$OPT" > "$tmp"
mv "$tmp" "$OPT"

exec /init "$@"
