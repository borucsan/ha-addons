# Home Assistant Add-on: Karakeep MCP Server

This add-on gives AI assistants access to your [Karakeep](https://karakeep.com) bookmarks, lists and tags over the [Model Context Protocol](https://modelcontextprotocol.io/). Clients (LobeHub, Claude, Cursor, …) connect to a **Streamable HTTP** endpoint on a host port, not through Home Assistant ingress — MCP clients cannot log in to Home Assistant.

Karakeep's own MCP server speaks **stdio only**. The add-on therefore wraps it with [supergateway](https://github.com/supercorp-ai/supergateway), which bridges stdio to Streamable HTTP and enforces the access token. Upstream versions are pinned in the `Dockerfile`; both packages are installed at build time, so no download is needed at startup.

## Available tools

- **Bookmarks** — search, read, create (text/URL), update, delete, read content, list membership.
- **Lists** — list/get/create/update/delete, list bookmarks, add/remove bookmarks.
- **Tags** — list/get/rename/delete, list a tag's bookmarks, attach/detach.
- **Assets and highlights** — signed asset URLs, list/get/create/update/delete highlights.

## Configuration

1. **Karakeep API address** — the address of your Karakeep instance reachable from Home Assistant, without a trailing slash (e.g. `https://karakeep.example.com` or `http://192.168.1.10:3000`).
2. **Karakeep API key** — create one in Karakeep → **Settings** → **API Keys**. The MCP server acts as this user.
3. **Custom headers** (optional) — a JSON object of extra headers sent to Karakeep, e.g. `{"CF-Access-Client-Id": "...", "CF-Access-Client-Secret": "..."}` when the instance sits behind Cloudflare Access.
4. **MCP access token** — a secret clients must send as `Authorization: Bearer <token>`. At least 16 characters; generate one with `openssl rand -hex 32`. The add-on does not start without it.
5. **Log level** — `debug`, `info` or `none` for the gateway.

If Karakeep is not reachable yet, the add-on retries for up to 5 minutes before stopping. A rejected API key or custom header stops it immediately; check the **Log** tab.

## Connecting a client

- **URL:** `http://<Home Assistant IP>:8765/mcp`
- **Transport:** Streamable HTTP
- **Header:** `Authorization: Bearer <MCP access token>`

### LobeHub

**Settings** → **Plugins** (or **Skills**) → **Add custom plugin** → **MCP**, choose **Streamable HTTP**, enter the URL above and add the `Authorization` header (or pick Bearer Token authentication and paste the token).

## Security

Anyone with the MCP access token can read, change and delete everything the Karakeep API key can. Keep port 8765 inside your local network; do not forward it to the internet. To restrict access further, use a Karakeep API key belonging to a user with only the permissions you need. The gateway also answers `GET /healthz` without a token.

## Disclaimer

The MCP server ([`@karakeep/mcp`](https://github.com/karakeep-app/karakeep/tree/main/apps/mcp)) is licensed **AGPL-3.0**; [supergateway](https://github.com/supercorp-ai/supergateway) is **MIT**. The add-on adds the token check, the startup wait and Home Assistant option handling.
