## 0.63.0-8

- Fix Home Assistant ingress returning 404: when `origin` is left empty, set `ORIGIN` from the Supervisor `ingress_url` (SvelteKit needs the full ingress base path for `/_app` assets).
- Default `origin` is now empty so ingress auto-detection runs; set `origin` manually for direct port / external proxy only.

## 0.63.0-1

- Initial release — Wishlist version 0.63.0.
- Persistent storage: database and image uploads are stored in addon_config (`/config/data` and `/config/uploads`).
- Ingress support with SSE streaming for real-time wishlist events.
- Optional header-based authentication for use with a custom reverse proxy.
