#!/bin/sh
# Unset empty optional vars so pydantic does not receive "" for optional fields.
set -e

cd /app

[ -z "${DISCORD_GUILD_ID:-}" ] && unset DISCORD_GUILD_ID
[ -z "${MEALIE_USERNAME:-}" ] && unset MEALIE_USERNAME
[ -z "${MEALIE_PASSWORD:-}" ] && unset MEALIE_PASSWORD
[ -z "${OPENAI_API_KEY:-}" ] && unset OPENAI_API_KEY

exec python src/main.py
