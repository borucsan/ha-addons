# Home Assistant Add-on: Mealie MCP Server

This add-on runs [mealie-mcp-server](https://github.com/rldiao/mealie-mcp-server) as a [Model Context Protocol](https://modelcontextprotocol.io/) server over **Streamable HTTP**. MCP clients (LobeHub, Claude, Cursor, …) connect to it and get tools for Mealie recipes, categories, tags, foods, units, shopping lists and meal plans.

The endpoint is published on a host port, not through Home Assistant ingress, because MCP clients cannot log in to Home Assistant.

## Configuration

1. **Mealie base URL** — an address of Mealie reachable from this add-on, without a trailing slash:
   - `http://<Home Assistant IP>:<Mealie port>` (e.g. `http://192.168.1.10:9925`) when Mealie runs as an add-on with a published port, or
   - the Mealie add-on's internal hostname, shown on its **Info** page, e.g. `http://xxxxxxxx-mealie:9000`.
2. **Mealie API key** — Mealie → **Profile** → **API Tokens**. The MCP server acts as this user.
3. **MCP access token** — a secret that clients must send as `Authorization: Bearer <token>`. At least 16 characters; generate one with `openssl rand -hex 32`. The add-on does not start without it.
4. **Enable AI recipe import** (optional) — adds the AI import tool; needs Mealie 3.23.0+ with a default AI provider.

If Mealie is not reachable yet (for example right after Home Assistant boots), the add-on retries for up to 5 minutes before stopping. A wrong API key stops it immediately; check the **Log** tab.

## Connecting a client

- **URL:** `http://<Home Assistant IP>:8765/mcp`
- **Transport:** Streamable HTTP
- **Header:** `Authorization: Bearer <MCP access token>`

### LobeHub

**Settings** → **Plugins** (or **Skills**) → **Add custom plugin** → **MCP**, choose **Streamable HTTP**, enter the URL above and add the `Authorization` header (or pick Bearer Token authentication and paste the token).

## Security

Anyone with the MCP access token can read, change and delete everything the Mealie API key can. Keep port 8765 inside your local network; do not forward it to the internet. To restrict access further, use a Mealie user with only the permissions you need.

## Disclaimer

Application behavior and licensing (MIT) follow the [mealie-mcp-server](https://github.com/rldiao/mealie-mcp-server) project. The add-on adds the token check and Home Assistant option handling.
