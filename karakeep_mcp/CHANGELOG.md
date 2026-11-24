## 1.0.1

- Changed the host port to 8766: Mealie MCP Server already uses 8765, so the two add-ons could not run together. Clients must use `http://<Home Assistant IP>:8766/mcp`.
- Documented the LobeHub private-IP (SSRF) allowlist in DOCS.md.

## 1.0.0

- Initial release: `@karakeep/mcp` 0.35.0 bridged from stdio to Streamable HTTP with `supergateway` 4.2.2 on port 8765 (`/mcp`).
- Requires a bearer token (`auth_token`) for every request, enforced by the gateway.
- Waits up to 5 minutes for Karakeep to become reachable at startup; optional custom headers (e.g. Cloudflare Access) are supported.
