#!/bin/sh
set -eu

OPT="/data/options.json"
TTY="/tmp/ttyOTBRNET"

NET="$(jq -r '.network_device' "$OPT")"
HOST="${NET%:*}"
PORT="${NET#*:}"

rm -f "$TTY"
socat -d -d pty,raw,echo=0,link="$TTY" tcp:"$HOST":"$PORT" >/tmp/socat.log 2>&1 &
sleep 1

tmp="$(mktemp)"
jq --arg dev "$TTY" '. + {device: $dev}' "$OPT" > "$tmp"
mv "$tmp" "$OPT"

exec /init

