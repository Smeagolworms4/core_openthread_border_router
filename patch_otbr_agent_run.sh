#!/bin/sh
# ==============================================================================
# Adapte le service otbr-agent de l'addon upstream aux RCP réseau (TCP).
#
# Upstream construit la radio URL ainsi :
#   flow_control=true  -> "&uart-flow-control"
#   flow_control=false -> "&uart-init-deassert"
#
# Avec un `network_device`, le RCP est atteint via un PTY socat branché sur du
# TCP : le contrôle de flux série n'a aucun sens. Pire, "uart-init-deassert"
# pousse otbr-agent à faire un ioctl(TIOCMBIC) sur le PTY, qui échoue avec
# ENOTTY ("tiocmbic: Inappropriate ioctl for device"). OpenFile() saute alors
# directement à sa sortie d'erreur, tcsetattr n'est jamais appelé (baudrate non
# appliqué) et le driver spinel échoue :
#   [C] Platform------: Init() at spinel_driver.cpp:87: Failure
#
# On retire donc les deux paramètres quand un network_device est configuré.
# ==============================================================================
set -eu

RUN_FILE="${RUN_FILE:-/etc/s6-overlay/s6-rc.d/otbr-agent/run}"
MARKER="custom-otbr: network device"
ANCHOR="^exec s6-notifyoncheck"

if [ ! -f "${RUN_FILE}" ]; then
    echo "ERROR: ${RUN_FILE} introuvable (l'image upstream a changé)" >&2
    exit 1
fi

if ! grep -q "${ANCHOR}" "${RUN_FILE}"; then
    echo "ERROR: motif '${ANCHOR}' introuvable dans ${RUN_FILE} (l'image upstream a changé)" >&2
    exit 1
fi

tmp="$(mktemp)"
awk -v marker="${MARKER}" '
/^exec s6-notifyoncheck/ && !patched {
    print "# " marker ": le RCP est joint via un PTY socat sur TCP, le contrôle"
    print "# de flux série ne s\047applique pas. En prime, uart-init-deassert fait"
    print "# échouer l\047ouverture du port (ioctl TIOCMBIC -> ENOTTY sur un PTY)."
    print "if bashio::config.has_value \047network_device\047; then"
    print "    bashio::log.info \"Network device in use: dropping UART flow control parameters.\""
    print "    flow_control=\"\""
    print "fi"
    print ""
    patched = 1
}
{ print }
' "${RUN_FILE}" > "${tmp}"

cat "${tmp}" > "${RUN_FILE}"
rm -f "${tmp}"

grep -q "${MARKER}" "${RUN_FILE}"
echo "[custom-otbr] ${RUN_FILE} patché (network device -> pas de contrôle de flux UART)"
