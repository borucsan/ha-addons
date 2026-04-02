## 1.0.4

- Stop using `environment:` template substitution (Supervisor passed literal `${option}` strings). Options are read from `/data/options.json` in `apply_addon_options.py` before starting the app.

## 1.0.3

- Dockerfile: use `FROM --platform=${TARGETPLATFORM}` so BuildKit pulls the layer for the supervisor’s target architecture (avoids amd64 binaries on arm64 when multi-arch manifests exist).
- Document multi-arch requirement for aarch64 Home Assistant; single-platform amd64 upstream images cause `exec format error` on ARM.

## 1.0.2

- Updated mealie-discord-import to 0.5

## 1.0.1

- Fixed addon_config

## 1.0.0

- Initial release: Home Assistant add-on wrapping `ghcr.io/borucsan/mealie-discord-import:sha-2f352bc`.
