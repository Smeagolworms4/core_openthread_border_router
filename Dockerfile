ARG OTBR_TAG=latest
ARG ARCH=amd64
FROM homeassistant/${ARCH}-addon-otbr:${OTBR_TAG}

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      socat \
      jq \
 && rm -rf /var/lib/apt/lists/*
COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
