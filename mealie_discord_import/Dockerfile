# syntax=docker/dockerfile:1
# TARGETPLATFORM is set by BuildKit to the supervisor target (linux/arm64, linux/amd64, …).
ARG BUILD_FROM
ARG BUILD_VERSION=0.0.0
ARG TARGETPLATFORM

FROM --platform=${TARGETPLATFORM} ${BUILD_FROM}

LABEL maintainer="Dawid Karwot <contact@dkarwot.me>"
LABEL io.hass.version=${BUILD_VERSION}
LABEL io.hass.type="addon"
LABEL io.hass.arch="aarch64|amd64"

USER root

COPY rootfs /

RUN chmod +x /ha-startup.sh

USER botuser

WORKDIR /app

CMD ["/ha-startup.sh"]
