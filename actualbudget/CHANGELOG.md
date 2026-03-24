## 1.4.0

- Added HTTPS support with automatic SSL certificate management:
  - If HA SSL certificates exist (`certfile`/`keyfile` options), they are used automatically.
  - Otherwise a self-signed certificate is generated and stored in addon_config (persists across restarts).
- Added `certfile` and `keyfile` configuration options (defaults: `fullchain.pem` / `privkey.pem`).
- Fixed data persistence: replaced non-functional cont-init.d script with a proper startup wrapper.
- "Open Web UI" button now opens `https://[HOST]:5006`.

## 1.2.0

- Removed HTTPS/SSL configuration, reverted to plain HTTP.
- Added "Open Web UI" button pointing to http://[HOST]:5006.

## 1.1.0

- Fixed data loss on update: replaced non-functional S6 cont-init.d script with a proper startup wrapper that persists data to addon_config before launching Actual Budget. Also removed ingress configuration as Actual Budget does not support subpath serving.

## 1.0.0

- Initial release - added Actual Budget: Local-first personal finance app for Home Assistant.
