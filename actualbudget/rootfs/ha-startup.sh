#!/bin/sh
# Runs before the original Actual Budget process.
# 1. Persists /data to addon_config (/config/data)
# 2. Sets up SSL: uses HA certs if available, otherwise generates a self-signed certificate.

# --- Data persistence ---
DATA_DEST="/config/data"
mkdir -p "${DATA_DEST}"

if [ ! -L "/data" ]; then
    if [ -d "/data" ]; then
        cp -a "/data/." "${DATA_DEST}/"
    fi
    rm -rf "/data"
    ln -s "${DATA_DEST}" "/data"
fi

# --- SSL setup ---
SSL_DIR="/config/ssl"
mkdir -p "${SSL_DIR}"

if [ -n "${CERTFILE}" ] && [ -f "/ssl/${CERTFILE}" ] && \
   [ -n "${KEYFILE}" ]  && [ -f "/ssl/${KEYFILE}" ]; then
    export ACTUAL_HTTPS_CERT="/ssl/${CERTFILE}"
    export ACTUAL_HTTPS_KEY="/ssl/${KEYFILE}"
    echo "Actual Budget: using HA SSL certificate (${CERTFILE})."
else
    if [ ! -f "${SSL_DIR}/cert.pem" ] || [ ! -f "${SSL_DIR}/key.pem" ]; then
        echo "Actual Budget: generating self-signed SSL certificate..."
        openssl req -x509 -nodes -newkey rsa:2048 \
            -keyout "${SSL_DIR}/key.pem" \
            -out "${SSL_DIR}/cert.pem" \
            -days 3650 \
            -subj "/CN=actual-budget" \
            2>/dev/null
    fi
    export ACTUAL_HTTPS_CERT="${SSL_DIR}/cert.pem"
    export ACTUAL_HTTPS_KEY="${SSL_DIR}/key.pem"
    echo "Actual Budget: using self-signed SSL certificate."
fi

exec node /app/app.js
