# Home Assistant Add-on: Mealie Discord Import

This add-on runs the [Mealie Discord Import](https://github.com/borucsan/mealie-discord-import) bot so you can import recipes from URLs into [Mealie](https://mealie.io/) via Discord slash commands.

## Prerequisites

- A Discord application and bot token ([Discord Developer Portal](https://discord.com/developers/applications)).
- **Message Content Intent** (and any intents required by your bot version) enabled for the bot.
- A running Mealie instance reachable from Home Assistant, with an API token (Mealie → Settings → API Tokens).

## Configuration

The add-on reads options from Home Assistant’s `/data/options.json` at startup (it does not rely on Docker `environment` substitution). The process runs as **root** inside the container so that file remains readable (Supervisor often mounts it with permissions that do not allow the upstream image’s non-root user to open it).

1. Fill in **Discord bot token** and **Mealie base URL** and **Mealie API token** (required).
2. Optionally set **Discord server (guild) ID** to register slash commands only on that server.
3. Optionally enable **AI fallback** and add an **OpenAI API key** if you want GPT to parse recipes when Mealie’s parser is insufficient.

## Usage

In Discord, use the bot’s slash commands (e.g. `/save_recipe` with a recipe URL — see the [upstream README](https://github.com/borucsan/mealie-discord-import)).

## Logs

View **Log** on the add-on page in Home Assistant to troubleshoot connection or token issues.

## Disclaimer

This add-on wraps the upstream Docker image `ghcr.io/borucsan/mealie-discord-import`. Application behavior and licensing follow the [mealie-discord-import](https://github.com/borucsan/mealie-discord-import) project.
