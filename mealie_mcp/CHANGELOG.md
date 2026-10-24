## 1.0.1

- Fixed the build on Supervisor 2026.04+: the base image and the upstream commit are now set in the Dockerfile instead of `build.yaml`, which Supervisor no longer applies (it built from `ghcr.io/home-assistant/base` with an empty commit, failing with HTTP 404).

## 1.0.0

- Initial release: builds mealie-mcp-server at commit `86ebf37` (2026-10-03) and serves it over Streamable HTTP on port 8765 (`/mcp`).
- Requires a bearer token (`auth_token`) for every request, since upstream has no authentication.
- Waits up to 5 minutes for Mealie to become reachable at startup.
