ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}

LABEL maintainer="Dawid Karwot <contact@dkarwot.me>" 
LABEL io.hass.version=${BUILD_VERSION} 
LABEL io.hass.type="addon" 
LABEL io.hass.arch="aarch64|amd64" 

# Move Wallos data directories to addon_config for persistence.
# HA mounts addon_config at /addon_configs/wallos inside the container.
RUN rm -rf /var/www/html/db /var/www/html/images/uploads/logos \
    && mkdir -p /addon_configs/wallos/db /addon_configs/wallos/logos \
    && ln -s /addon_configs/wallos/db /var/www/html/db \
    && ln -s /addon_configs/wallos/logos /var/www/html/images/uploads/logos

EXPOSE 80