# Mealie MCP Server — Home Assistant Add-on

[![Supports aarch64 Architecture][aarch64-shield]]
[![Supports amd64 Architecture][amd64-shield]]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg

This add-on runs [mealie-mcp-server](https://github.com/rldiao/mealie-mcp-server) over the MCP **Streamable HTTP** transport, so AI assistants such as LobeHub can search, create and edit recipes, shopping lists and meal plans in [Mealie](https://mealie.io/).

Upstream publishes no Docker image, so the add-on builds a pinned upstream commit (`MEALIE_MCP_REF` in the `Dockerfile`). The first install takes a few minutes.

## Installation

Add the [repository](https://github.com/borucsan/ha-addons) in Home Assistant → **Settings** → **Add-ons** → **Add-on store** → **Repositories**, then install **Mealie MCP Server**. Setup and client configuration are described in the **Documentation** tab.
