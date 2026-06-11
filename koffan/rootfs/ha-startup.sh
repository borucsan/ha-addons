#!/bin/sh
# Runs before the original Koffan process.
# Persists /data to addon_config (/config/data).

DATA_DEST="/config/data"
mkdir -p "${DATA_DEST}"

if [ ! -L "/data" ]; then
    if [ -d "/data" ]; then
        cp -a "/data/." "${DATA_DEST}/"
    fi
    rm -rf "/data"
    ln -s "${DATA_DEST}" "/data"
fi

exec /app/shopping-list
