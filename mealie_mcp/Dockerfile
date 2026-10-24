ARG BUILD_FROM
ARG BUILD_VERSION=0.0.0

FROM ${BUILD_FROM} AS builder

COPY --from=ghcr.io/astral-sh/uv:0.8.22 /uv /bin/uv

ARG MEALIE_MCP_REF
ADD https://github.com/rldiao/mealie-mcp-server/archive/${MEALIE_MCP_REF}.tar.gz /tmp/src.tar.gz
RUN mkdir /app && tar -xzf /tmp/src.tar.gz -C /app --strip-components=1

WORKDIR /app
RUN uv sync --frozen --no-dev

FROM ${BUILD_FROM}

ARG BUILD_VERSION
LABEL maintainer="Dawid Karwot <contact@dkarwot.me>"
LABEL io.hass.version=${BUILD_VERSION}
LABEL io.hass.type="addon"
LABEL io.hass.arch="aarch64|amd64"

WORKDIR /app
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/src /app/src
COPY rootfs /

ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8765

CMD ["python", "/ha-mcp.py"]
