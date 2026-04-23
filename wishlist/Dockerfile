ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}

# Matches upstream Wishlist / SvelteKit adapter-node (PORT=3280 in config.yaml).
EXPOSE 3280

LABEL maintainer="Dawid Karwot <contact@dkarwot.me>"
LABEL io.hass.version=${BUILD_VERSION}
LABEL io.hass.type="addon"
LABEL io.hass.arch="aarch64|amd64"

COPY rootfs /

RUN chmod +x /usr/src/app/ha-startup.sh

ENTRYPOINT ["sh", "/usr/src/app/ha-startup.sh"]
