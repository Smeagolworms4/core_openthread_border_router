ARG OTBR_TAG=2.15.3
ARG ARCH=amd64
FROM homeassistant/${ARCH}-addon-otbr:${OTBR_TAG}

RUN apk add --no-cache socat jq
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
