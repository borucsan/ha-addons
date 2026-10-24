# Base image lives here: Supervisor 2026.04+ no longer takes it from build.yaml.
FROM ghcr.io/actualbudget/actual:26.10.0-alpine

ARG BUILD_VERSION

LABEL maintainer="Dawid Karwot <contact@dkarwot.me>" 
LABEL io.hass.version=${BUILD_VERSION} 
LABEL io.hass.type="addon" 
LABEL io.hass.arch="aarch64|amd64" 

RUN apk add --no-cache openssl

COPY rootfs /

RUN chmod +x /ha-startup.sh

EXPOSE 5006

CMD ["/ha-startup.sh"]
