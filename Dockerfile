# Image upstream complète, calculée par build_images.yml :
#  - >= 3.4.0 : ghcr.io/home-assistant/app-openthread-border-router:<v> (multi-arch)
#  - <  3.4.0 : homeassistant/<arch>-addon-otbr:<v> (Docker Hub, plus alimenté)
ARG BASE_IMAGE=ghcr.io/home-assistant/app-openthread-border-router:stable
FROM ${BASE_IMAGE}

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
