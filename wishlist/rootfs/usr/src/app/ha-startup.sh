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

# Optional `origin` in add-on config: if the user omits it or the Supervisor does not
# substitute, ORIGIN can be the literal "${origin}" and Wishlist will refuse to start.
# Unset it so the app can derive the URL from proxy headers (ingress) or set `origin` in
# the add-on to a real URL (e.g. http://ha-ip:3280) when not using ingress.
if [ -z "$ORIGIN" ] || [ "$ORIGIN" = '${origin}' ]; then
	unset ORIGIN
fi

exec sh /usr/src/app/entrypoint.sh
