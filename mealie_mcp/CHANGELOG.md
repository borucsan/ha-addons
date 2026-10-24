## 1.0.0

- Initial release: builds mealie-mcp-server at commit `86ebf37` (2026-10-03) and serves it over Streamable HTTP on port 8765 (`/mcp`).
- Requires a bearer token (`auth_token`) for every request, since upstream has no authentication.
- Waits up to 5 minutes for Mealie to become reachable at startup.
