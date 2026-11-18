# Karakeep MCP Server — Home Assistant Add-on

[![Supports aarch64 Architecture][aarch64-shield]]
[![Supports amd64 Architecture][amd64-shield]]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg

This add-on runs Karakeep's [MCP server](https://docs.karakeep.com/integrations/mcp/) over the MCP **Streamable HTTP** transport, so AI assistants such as LobeHub can search, create and edit bookmarks, lists and tags in [Karakeep](https://karakeep.com/).

Karakeep's MCP server is stdio-only, so the add-on uses [supergateway](https://github.com/supercorp-ai/supergateway) as a bridge. Both upstream packages are pinned and installed at build time (Node 24); the first install takes a few minutes.

## Installation

Add the [repository](https://github.com/borucsan/ha-addons) in Home Assistant → **Settings** → **Add-ons** → **Add-on store** → **Repositories**, then install **Karakeep MCP Server**. Setup and client configuration are described in the **Documentation** tab.
