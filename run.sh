#!/bin/sh
set -e

# 1) Créer un vrai TTY (PTY) dans le container
socat pty,raw,echo=0,link=/dev/ttyFake >/tmp/socat.log 2>&1 &
sleep 1

# 2) Injecter device dans la config OTBR
jq '. + {device: "/dev/ttyFake"}' /data/options.json > /tmp/options.json
mv /tmp/options.json /data/options.json

# 3) Lancer l'addon OTBR original
exec /init
