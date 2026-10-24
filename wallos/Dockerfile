# Base image lives here: Supervisor 2026.04+ no longer takes it from build.yaml.
FROM ghcr.io/ellite/wallos:5.10.2

ARG BUILD_VERSION

LABEL maintainer="Dawid Karwot <contact@dkarwot.me>" 
LABEL io.hass.version=${BUILD_VERSION} 
LABEL io.hass.type="addon" 
LABEL io.hass.arch="aarch64|amd64" 

COPY rootfs /

RUN chmod +x /var/www/html/ha-startup.sh

EXPOSE 80

CMD ["/var/www/html/ha-startup.sh"]