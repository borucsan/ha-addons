## 2.11.0-5

- Replaced fragile nginx text-replacement of JavaScript patterns with a proper JS monkey-patch (`ha-ingress-patch.js`) injected at the start of every page. Patches `window.fetch`, `XMLHttpRequest.open` (htmx), and `WebSocket` (including absolute same-origin URLs like `wss://host/ws`) so all API calls go through the ingress path regardless of how the URL was constructed.

## 2.11.0-4

- Fixed POST/PUT/DELETE requests: Koffan uses JavaScript `fetch()` calls (via Alpine.js) instead of htmx attributes — added sub_filter patterns for single-quoted, double-quoted and backtick template literal variants.

## 2.11.0-3

- Fixed base path issue with HA ingress: added nginx reverse proxy that rewrites absolute paths (`/static/`, htmx attributes, WebSocket) to include the ingress base path so all assets and requests resolve correctly inside the ingress iframe.
- Added `ingress_stream: true` for proper WebSocket support through ingress.

## 2.11.0-2

- Disabled Koffan's built-in authentication — Home Assistant ingress already requires HA login.
- Removed `app_password` and `disable_auth` configuration options (no longer needed).

## 2.11.0-1

- Initial release - added Koffan: Free self-hosted groceries list for families and shared households, version 2.11.0.
