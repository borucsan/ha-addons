#!/bin/sh
# Runs before the original Wallos startup.sh.
# Moves data directories to addon_config (persistent storage) and replaces them with symlinks.

ADDON_CONFIG="/addon_configs/wallos"
DB_SRC="/var/www/html/db"
LOGOS_SRC="/var/www/html/images/uploads/logos"

mkdir -p "${ADDON_CONFIG}/db"
mkdir -p "${ADDON_CONFIG}/logos"

if [ ! -L "${DB_SRC}" ]; then
    if [ -d "${DB_SRC}" ]; then
        cp -a "${DB_SRC}/." "${ADDON_CONFIG}/db/"
    fi
    rm -rf "${DB_SRC}"
    ln -s "${ADDON_CONFIG}/db" "${DB_SRC}"
fi

if [ ! -L "${LOGOS_SRC}" ]; then
    if [ -d "${LOGOS_SRC}" ]; then
        cp -a "${LOGOS_SRC}/." "${ADDON_CONFIG}/logos/"
    fi
    rm -rf "${LOGOS_SRC}"
    ln -s "${ADDON_CONFIG}/logos" "${LOGOS_SRC}"
fi

chown -R www-data:www-data "${ADDON_CONFIG}/db" "${ADDON_CONFIG}/logos"

exec /var/www/html/startup.sh
