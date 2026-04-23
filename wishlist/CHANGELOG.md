## 0.63.0-16

- **Ingress 404 (white / “not found”):** SvelteKit returns `Location: /lists` etc. In the Home Assistant iframe that resolves to the **core** host path (`/lists`), not under `/api/hassio_ingress/...`. The Caddy layer now rewrites `Location` on the response to `{X-Ingress-Path}/…` (trimmed) so 3xx redirects stay inside the ingress.

## 0.63.0-15

- **Caddy** `Caddyfile` override: add global `servers { trusted_proxies static private_ranges }` so the Supervisor (and other in-path proxies) are trusted and `X-Forwarded-*` is forwarded correctly to SvelteKit; add `X-Ingress-Path` to the upstream. Mitigates ingress **404** when direct `:3280` still works.

## 0.63.0-14

- Document and restore **`ingress_port: 3280`** and **`3280/tcp: 3280`**: the official image serves traffic through **Caddy** on 3280, which reverse-proxies to SvelteKit on 3000. Connecting ingress to 3000 bypasses Caddy; matching upstream `ports: 3280:3280` is correct even though the Node process listens on 3000 inside the stack.

## 0.63.0-13

- Fix **ingress** when the app listens on **3000**: set `ingress_port: 3000` (Supervisor targets the container port). Map host `3280` → container `3000` with `3000/tcp: 3280` (HA format: in-app port / host port). The previous `ingress_port: 3280` with an app on 3000 made ingress fail while `http://<ip>:3280` could still work with an inconsistent port map.

## 0.63.0-11

- Listen on port **3280** like the upstream Wishlist image: set `PORT=3280` in the add-on environment and `EXPOSE 3280` in the Dockerfile so ingress and host mapping match the running process (adapter-node defaults to 3000 without this).

## 0.63.0-9

- Fix `Invalid ORIGIN` when using ingress: Supervisor’s `ingress_url` is only a path (`/api/hassio_ingress/...`). Build a full `http(s)://` URL with Home Assistant’s external/internal URL from `/core/api/config` (requires `homeassistant_api: true` on the add-on). Fallback: `http://homeassistant:8123` if the config call is unavailable.

## 0.63.0-8

- Fix Home Assistant ingress returning 404: when `origin` is left empty, set `ORIGIN` from the Supervisor `ingress_url` (SvelteKit needs the full ingress base path for `/_app` assets).
- Default `origin` is now empty so ingress auto-detection runs; set `origin` manually for direct port / external proxy only.

## 0.63.0-1

- Initial release — Wishlist version 0.63.0.
- Persistent storage: database and image uploads are stored in addon_config (`/config/data` and `/config/uploads`).
- Ingress support with SSE streaming for real-time wishlist events.
- Optional header-based authentication for use with a custom reverse proxy.
