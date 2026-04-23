#!/bin/sh
# Runs before the original Wishlist entrypoint.sh.
# Moves data directories to addon_config (persistent storage) and replaces them with symlinks.

ADDON_CONFIG="/config"
DATA_SRC="/usr/src/app/data"
UPLOADS_SRC="/usr/src/app/uploads"

mkdir -p "${ADDON_CONFIG}/data"
mkdir -p "${ADDON_CONFIG}/uploads"

if [ ! -L "${DATA_SRC}" ]; then
    if [ -d "${DATA_SRC}" ]; then
        cp -a "${DATA_SRC}/." "${ADDON_CONFIG}/data/"
    fi
    rm -rf "${DATA_SRC}"
    ln -s "${ADDON_CONFIG}/data" "${DATA_SRC}"
fi

if [ ! -L "${UPLOADS_SRC}" ]; then
    if [ -d "${UPLOADS_SRC}" ]; then
        cp -a "${UPLOADS_SRC}/." "${ADDON_CONFIG}/uploads/"
    fi
    rm -rf "${UPLOADS_SRC}"
    ln -s "${ADDON_CONFIG}/uploads" "${UPLOADS_SRC}"
fi

chown -R node:node "${ADDON_CONFIG}/data" "${ADDON_CONFIG}/uploads"

exec sh /usr/src/app/entrypoint.sh
