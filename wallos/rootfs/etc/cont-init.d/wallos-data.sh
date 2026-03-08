#!/usr/bin/with-contenv bashio
# Runs after HA mounts addon_config at /addon_configs/wallos.
# Moves Wallos data directories there and replaces them with symlinks.

ADDON_CONFIG="/addon_configs/wallos"
DB_SRC="/var/www/html/db"
LOGOS_SRC="/var/www/html/images/uploads/logos"

# --- database ---
mkdir -p "${ADDON_CONFIG}/db"
if [ ! -L "${DB_SRC}" ]; then
    if [ -d "${DB_SRC}" ]; then
        cp -a "${DB_SRC}/." "${ADDON_CONFIG}/db/"
    fi
    rm -rf "${DB_SRC}"
    ln -s "${ADDON_CONFIG}/db" "${DB_SRC}"
fi

# --- logos ---
mkdir -p "${ADDON_CONFIG}/logos"
if [ ! -L "${LOGOS_SRC}" ]; then
    if [ -d "${LOGOS_SRC}" ]; then
        cp -a "${LOGOS_SRC}/." "${ADDON_CONFIG}/logos/"
    fi
    rm -rf "${LOGOS_SRC}"
    ln -s "${ADDON_CONFIG}/logos" "${LOGOS_SRC}"
fi

# Ensure www-data can write to both directories
chown -R www-data:www-data "${ADDON_CONFIG}/db" "${ADDON_CONFIG}/logos"
chmod -R 755 "${ADDON_CONFIG}/db" "${ADDON_CONFIG}/logos"

bashio::log.info "Wallos data directories linked to addon_config."
