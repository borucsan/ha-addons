## 1.0.0

- Initial release - added Actual Budget: Local-first personal finance app for Home Assistant.


## 1.1.0

- Fixed data loss on update: replaced non-functional S6 cont-init.d script with a proper startup wrapper that persists data to addon_config before launching Actual Budget. Also removed ingress configuration as Actual Budget.