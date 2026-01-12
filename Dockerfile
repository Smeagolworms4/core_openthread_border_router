ARG OTBR_TAG=latest
ARG ARCH=amd64
FROM homeassistant/${ARCH}-addon-otbr:${OTBR_TAG}

RUN apk add --no-cache socat jq
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
