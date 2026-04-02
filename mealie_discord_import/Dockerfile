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

# Upstream image uses `botuser`, but Supervisor stores add-on options in
# `/data/options.json` with permissions that are not readable by that user.
# Run as root so we can read options and start the bot (common for HA add-ons).
USER root

WORKDIR /app

CMD ["/ha-startup.sh"]
