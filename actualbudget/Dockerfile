ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}

LABEL maintainer="Dawid Karwot <contact@dkarwot.me>" 
LABEL io.hass.version=${BUILD_VERSION} 
LABEL io.hass.type="addon" 
LABEL io.hass.arch="aarch64|amd64" 

RUN apk add --no-cache openssl

COPY rootfs /

RUN chmod +x /ha-startup.sh

EXPOSE 5006

CMD ["/ha-startup.sh"]
