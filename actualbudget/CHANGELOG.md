## 1.2.1

- Fixed "Open Web UI" button (webui) pointing to http://[HOST]:5006.

## 1.2.0

- Added HTTPS support via HA SSL certificates (ACTUAL_HTTPS_CERT / ACTUAL_HTTPS_KEY).
- Added `certfile` and `keyfile` configuration options.
- Added "Open Web UI" button (webui) pointing to https://[HOST]:5006.

## 1.1.0

- Fixed data loss on update: replaced non-functional S6 cont-init.d script with a proper startup wrapper that persists data to addon_config before launching Actual Budget. Also removed ingress configuration as Actual Budget does not support subpath serving.

## 1.0.0

- Initial release - added Actual Budget: Local-first personal finance app for Home Assistant.
