## 4.8.2-1

- Updated Wallos to version 4.8.2.
- moved to wallos versioning

## 1.4.0

- Fixed persistent storage: corrected addon_config mount path to `/config` (HA Supervisor maps `addon_config` to `/config` inside the container, not `/addon_config`).

## 1.3.0

- Fixed incorrect addon_config mount path: `/addon_configs/wallos` → `/addon_config` (correct HA Supervisor path inside container).

## 1.2.0

- Fixed data loss on update: replaced non-functional S6 cont-init.d script with a proper startup wrapper that persists database and logos to addon_config before launching Wallos.

## 1.1.0

- Updated Wallos to version 4.7.3.

## 1.0.0

- Initial release - added Wallos: Open-Source Personal Subscription Tracker version 4.6.2 for Home Assistant.
