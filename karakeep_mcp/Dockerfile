# Base image and pinned upstream versions live here: Supervisor 2026.04+ no
# longer takes them from build.yaml. Karakeep's MCP server is stdio-only, so
# supergateway bridges it to Streamable HTTP and enforces the access token.
FROM node:24-slim

ARG KARAKEEP_MCP_VERSION=0.35.0
ARG SUPERGATEWAY_VERSION=4.2.2

RUN npm install -g \
      "@karakeep/mcp@${KARAKEEP_MCP_VERSION}" \
      "supergateway@${SUPERGATEWAY_VERSION}" \
    && npm cache clean --force

ARG BUILD_VERSION
LABEL maintainer="Dawid Karwot <contact@dkarwot.me>"
LABEL io.hass.version=${BUILD_VERSION}
LABEL io.hass.type="addon"
LABEL io.hass.arch="aarch64|amd64"

COPY rootfs /

EXPOSE 8765

CMD ["node", "/run.js"]
