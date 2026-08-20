ARG OTBR_TAG=latest
ARG ARCH=amd64
FROM homeassistant/${ARCH}-addon-otbr:${OTBR_TAG}

# L'addon upstream gère nativement l'option `network_device` (service
# socat-otbr-tcp qui expose le RCP TCP sur /tmp/ttyOTBR). On se contente donc :
#  - de neutraliser la migration des settings (elle re-provisionne le RCP quand
#    le chemin de l'adaptateur change, ce qui n'a pas de sens ici),
#  - d'adapter la radio URL au PTY socat (cf. patch_otbr_agent_run.sh).

COPY migrate_otbr_settings.py /usr/local/bin/migrate_otbr_settings.py
COPY patch_otbr_agent_run.sh /tmp/patch_otbr_agent_run.sh

RUN chmod +x /usr/local/bin/migrate_otbr_settings.py /tmp/patch_otbr_agent_run.sh \
 && /tmp/patch_otbr_agent_run.sh \
 && rm -f /tmp/patch_otbr_agent_run.sh

ENTRYPOINT ["/init"]
