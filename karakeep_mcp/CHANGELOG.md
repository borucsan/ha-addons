## 1.0.0

- Initial release: `@karakeep/mcp` 0.35.0 bridged from stdio to Streamable HTTP with `supergateway` 4.2.2 on port 8765 (`/mcp`).
- Requires a bearer token (`auth_token`) for every request, enforced by the gateway.
- Waits up to 5 minutes for Karakeep to become reachable at startup; optional custom headers (e.g. Cloudflare Access) are supported.
