ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}

LABEL maintainer="Dawid Karwot <contact@dkarwot.me>" 
LABEL io.hass.version=${BUILD_VERSION} 
LABEL io.hass.type="addon" 
LABEL io.hass.arch="aarch64|amd64" 

COPY rootfs /

RUN chmod +x /var/www/html/ha-startup.sh

EXPOSE 80

CMD ["/var/www/html/ha-startup.sh"]