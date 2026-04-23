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

# When the Supervisor does not expand add-on options, env values can be the literal
# "${option_name}" string. Match defaults from config.yaml "options".
if [ -z "$TZ" ] || [ "$TZ" = '${timezone}' ]; then
	export TZ=UTC
fi
if [ -z "$ORIGIN" ] || [ "$ORIGIN" = '${origin}' ]; then
	unset ORIGIN
fi
if [ -z "$TOKEN_TIME" ] || [ "$TOKEN_TIME" = '${token_time}' ]; then
	export TOKEN_TIME=72
fi
if [ -z "$DEFAULT_CURRENCY" ] || [ "$DEFAULT_CURRENCY" = '${default_currency}' ]; then
	export DEFAULT_CURRENCY=USD
fi
if [ -z "$MAX_IMAGE_SIZE" ] || [ "$MAX_IMAGE_SIZE" = '${max_image_size}' ]; then
	export MAX_IMAGE_SIZE=5000000
fi
# Upstream may map MAX_IMAGE_SIZE -> BODY_SIZE_LIMIT; fix if left unsubstituted.
if [ -z "$BODY_SIZE_LIMIT" ] || [ "$BODY_SIZE_LIMIT" = '${max_image_size}' ]; then
	export BODY_SIZE_LIMIT=5000000
fi
if [ -z "$HEADER_AUTH_ENABLED" ] || [ "$HEADER_AUTH_ENABLED" = '${header_auth_enabled}' ]; then
	export HEADER_AUTH_ENABLED=false
fi
if [ -z "$HEADER_USERNAME" ] || [ "$HEADER_USERNAME" = '${header_username}' ]; then
	export HEADER_USERNAME="X-Remote-User-Name"
fi
if [ -z "$HEADER_NAME" ] || [ "$HEADER_NAME" = '${header_name}' ]; then
	export HEADER_NAME="X-Remote-User-Display-Name"
fi
if [ -z "$HEADER_EMAIL" ] || [ "$HEADER_EMAIL" = '${header_email}' ]; then
	export HEADER_EMAIL="X-Remote-Email"
fi

# SvelteKit resolves links and static assets from ORIGIN. HA ingress serves the app only
# under /api/hassio_ingress/<entry>/...; if ORIGIN is missing, the browser requests /_app/
# at the host root and Home Assistant returns 404. With an empty `origin` option, take
# the public ingress URL from the Supervisor API (same token the UI uses).
if [ -z "$ORIGIN" ] && [ -n "$SUPERVISOR_TOKEN" ]; then
	INGRESS_URL=$(
		node -e '
const api = process.env.SUPERVISOR_API || "http://supervisor";
const token = process.env.SUPERVISOR_TOKEN;
(async () => {
	if (!token) return;
	const base = api.endsWith("/") ? api : api + "/";
	const u = new URL("addons/self/info", base);
	const r = await fetch(u, { headers: { Authorization: "Bearer " + token } });
	if (!r.ok) return;
	const j = await r.json();
	const url = j.data && j.data.ingress_url;
	if (url && typeof url === "string")
		process.stdout.write(url.replace(/\/$/, ""));
})().catch(() => {});
' 2>/dev/null
	)
	if [ -n "$INGRESS_URL" ]; then
		export ORIGIN="$INGRESS_URL"
	fi
fi

exec sh /usr/src/app/entrypoint.sh
