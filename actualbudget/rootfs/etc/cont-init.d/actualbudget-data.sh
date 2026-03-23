#!/usr/bin/with-contenv bashio
# Moves Actual Budget data directory to addon_config and replaces it with a symlink.

ADDON_CONFIG="/config"
DATA_SRC="/data/server-files"
USER_SRC="/data/user-files"

mkdir -p "${ADDON_CONFIG}/server-files"
mkdir -p "${ADDON_CONFIG}/user-files"

if [ ! -L "${DATA_SRC}" ]; then
    if [ -d "${DATA_SRC}" ]; then
        cp -a "${DATA_SRC}/." "${ADDON_CONFIG}/server-files/"
    fi
    rm -rf "${DATA_SRC}"
    ln -s "${ADDON_CONFIG}/server-files" "${DATA_SRC}"
fi

if [ ! -L "${USER_SRC}" ]; then
    if [ -d "${USER_SRC}" ]; then
        cp -a "${USER_SRC}/." "${ADDON_CONFIG}/user-files/"
    fi
    rm -rf "${USER_SRC}"
    ln -s "${ADDON_CONFIG}/user-files" "${USER_SRC}"
fi

bashio::log.info "Actual Budget data directories linked to addon_config."
