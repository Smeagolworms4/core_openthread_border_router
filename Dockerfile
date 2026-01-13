ARG OTBR_TAG=latest
ARG ARCH=amd64
FROM homeassistant/${ARCH}-addon-otbr:${OTBR_TAG}

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      socat \
      jq \
 && rm -rf /var/lib/apt/lists/*


COPY migrate_otbr_settings.py /usr/local/bin/migrate_otbr_settings.py
RUN chmod +x /usr/local/bin/migrate_otbr_settings.py

COPY run.sh /run.sh
RUN chmod +x /run.sh


ENTRYPOINT ["/run.sh"]
