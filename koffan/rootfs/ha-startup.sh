#!/bin/sh
# Persists /data to addon_config, then starts the Go app on an internal port
# and nginx on port 8080 (ingress port). nginx rewrites absolute paths in HTML/JS
# responses to include the HA ingress base path so assets and htmx requests resolve
# correctly inside the ingress iframe.

DATA_DEST="/config/data"
mkdir -p "${DATA_DEST}"

if [ ! -L "/data" ]; then
    if [ -d "/data" ]; then
        cp -a "/data/." "${DATA_DEST}/"
    fi
    rm -rf "/data"
    ln -s "${DATA_DEST}" "/data"
fi

mkdir -p /tmp/nginx/client_body /tmp/nginx/proxy

# Auth is handled by HA ingress — no need for Koffan's own login.
export DISABLE_AUTH=true
# Run Go app on internal port 3000; nginx listens on 8080 (ingress_port).
export PORT=3000

/app/shopping-list &

# Wait until the Go app is accepting connections (max 10 s).
i=0
while [ $i -lt 20 ]; do
    wget -q -O /dev/null http://127.0.0.1:3000/api/version 2>/dev/null && break
    sleep 0.5
    i=$((i + 1))
done

exec nginx
