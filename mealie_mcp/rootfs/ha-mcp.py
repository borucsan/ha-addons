#!/usr/bin/env python3
"""Run mealie-mcp-server over Streamable HTTP with Home Assistant add-on options.

Reads /data/options.json, waits for Mealie to answer (it may start after this
add-on), and serves the upstream MCP app behind a bearer-token check, because
upstream has no authentication of its own.
"""
import hmac
import json
import logging
import os
import sys
import time

sys.path.insert(0, "/app/src")

import uvicorn  # noqa: E402
from mealie import MealieFetcher  # noqa: E402
from server import ServerConfig, _configure_logging, create_server  # noqa: E402

logger = logging.getLogger("ha-mealie-mcp")

OPTIONS_PATH = "/data/options.json"
MIN_TOKEN_LENGTH = 16
MEALIE_WAIT_SECONDS = 300
MEALIE_RETRY_SECONDS = 5


class BearerAuth:
    """ASGI middleware that rejects HTTP requests without the expected token."""

    def __init__(self, app, token: str):
        self.app = app
        self.expected = f"Bearer {token}".encode()

    async def __call__(self, scope, receive, send):
        if scope["type"] == "http":
            auth = dict(scope["headers"]).get(b"authorization", b"")
            if not hmac.compare_digest(auth, self.expected):
                await send({
                    "type": "http.response.start",
                    "status": 401,
                    "headers": [
                        (b"content-type", b"application/json"),
                        (b"www-authenticate", b"Bearer"),
                    ],
                })
                await send({
                    "type": "http.response.body",
                    "body": b'{"error":"unauthorized"}',
                })
                return
        await self.app(scope, receive, send)


def load_options() -> dict:
    with open(OPTIONS_PATH, encoding="utf-8") as f:
        o = json.load(f)

    def s(key: str, default: str = "") -> str:
        v = o.get(key)
        return default if v is None else str(v).strip()

    token = s("auth_token")
    if len(token) < MIN_TOKEN_LENGTH:
        sys.exit(
            f"auth_token must be at least {MIN_TOKEN_LENGTH} characters "
            "(e.g. generate one with `openssl rand -hex 32`)"
        )

    os.environ["MEALIE_BASE_URL"] = s("mealie_base_url").rstrip("/")
    os.environ["MEALIE_API_KEY"] = s("mealie_api_key")
    os.environ["MEALIE_ENABLE_AI_IMPORT"] = "true" if o.get("enable_ai_import") else "false"
    os.environ["LOG_LEVEL"] = s("log_level", "INFO") or "INFO"
    os.environ["MCP_TRANSPORT"] = "streamable-http"
    os.environ["MCP_HOST"] = "0.0.0.0"
    os.environ["MCP_PORT"] = "8765"
    return {"auth_token": token}


def wait_for_mealie(config: ServerConfig) -> None:
    """Retry while Mealie is unreachable; fail fast on HTTP errors (bad URL or key)."""
    deadline = time.monotonic() + MEALIE_WAIT_SECONDS
    while True:
        try:
            MealieFetcher(config.base_url, config.api_key).close()
            return
        except (ConnectionError, TimeoutError) as error:
            if time.monotonic() >= deadline:
                sys.exit(f"Mealie at {config.base_url} is unreachable: {error}")
            logger.warning(
                "Mealie at %s is not reachable yet (%s), retrying in %ds",
                config.base_url, error, MEALIE_RETRY_SECONDS,
            )
            time.sleep(MEALIE_RETRY_SECONDS)


def main() -> None:
    options = load_options()
    config = ServerConfig.from_environment()
    _configure_logging(config.log_level)
    wait_for_mealie(config)

    server = create_server(config)
    app = BearerAuth(server.streamable_http_app(), options["auth_token"])

    logger.info("Serving MCP (Streamable HTTP) on http://0.0.0.0:%d/mcp", config.port)
    # Same as upstream FastMCP.run(): keep one Mealie client alive between sessions.
    with server.client_provider.acquire():
        uvicorn.run(
            app,
            host=config.host,
            port=config.port,
            log_level=config.log_level.lower(),
        )


if __name__ == "__main__":
    main()
