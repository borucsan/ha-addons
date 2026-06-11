#!/bin/sh
# Runs before the original Koffan process.
# Persists /data to addon_config (/config/data).
# Forces DISABLE_AUTH=true — HA ingress already requires HA login.

DATA_DEST="/config/data"
mkdir -p "${DATA_DEST}"

if [ ! -L "/data" ]; then
    if [ -d "/data" ]; then
        cp -a "/data/." "${DATA_DEST}/"
    fi
    rm -rf "/data"
    ln -s "${DATA_DEST}" "/data"
fi

export DISABLE_AUTH=true

exec /app/shopping-list
