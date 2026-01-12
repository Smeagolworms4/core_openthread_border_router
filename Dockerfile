ARG OTBR_TAG=stable
ARG ARCH=amd64
FROM ghcr.io/home-assistant/${ARCH}-addon-otbr:${OTBR_TAG}

RUN apk add --no-cache socat jq
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
