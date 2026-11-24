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

## Troubleshooting: LobeHub SSRF protection

Newer LobeHub versions block server-side MCP connections to private IP addresses with an error like `The MCP server address resolves to a private ... IP address`. On a **self-hosted** LobeHub, allow the Home Assistant IP and restart LobeHub:

```
SSRF_ALLOW_PRIVATE_IP_ADDRESS=0
SSRF_ALLOW_IP_ADDRESS_LIST=192.168.1.10
```

`SSRF_ALLOW_IP_ADDRESS_LIST` takes comma-separated **IP addresses** (not hostnames); replace the example with your Home Assistant IP. Setting `SSRF_ALLOW_PRIVATE_IP_ADDRESS=1` allows all private IPs but disables SSRF protection entirely, so the allowlist is safer.

If you use **hosted LobeHub**, it cannot reach your LAN and these variables are not available: publish the endpoint behind a trusted HTTPS reverse proxy or tunnel instead, keeping the `Authorization: Bearer <token>` requirement.

## Security

Anyone with the MCP access token can read, change and delete everything the Mealie API key can. Keep port 8765 inside your local network; do not forward it to the internet. To restrict access further, use a Mealie user with only the permissions you need.

## Disclaimer

Application behavior and licensing (MIT) follow the [mealie-mcp-server](https://github.com/rldiao/mealie-mcp-server) project. The add-on adds the token check and Home Assistant option handling.
