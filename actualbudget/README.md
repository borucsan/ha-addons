# Actual Budget Home Assistant Add-on

[![GitHub Release][releases-shield]][releases]
![Project Stage][project-stage-shield]
[![License][license-shield]](LICENSE)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]

![Project Maintenance][maintenance-shield]
[![GitHub Activity][commits-shield]][commits]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg

[commits-shield]: https://img.shields.io/github/commit-activity/y/borucsan/ha-addons.svg
[commits]: https://github.com/borucsan/ha-addons/commits/main
[issue]: https://github.com/borucsan/ha-addons/issues
[license-shield]: https://img.shields.io/github/license/borucsan/ha-addons.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[releases-shield]: https://img.shields.io/github/v/release/borucsan/ha-addons.svg
[releases]: https://github.com/borucsan/ha-addons/releases
[project-stage-shield]: https://img.shields.io/badge/project%20stage-experimental-yellow.svg

This add-on runs [Actual Budget](https://actualbudget.org) inside Home Assistant OS.

Actual Budget is a local-first, privacy-focused personal finance application with a powerful budgeting interface.

## Installation

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fborucsan%2Fha-addons)

Install the **Actual Budget** add-on from this repository and start it.

## Configuration

- **timezone** (default: `UTC`)
  - Timezone used by the Actual Budget container, e.g. `Europe/Warsaw`.

## Disclaimers and copyright information

This add-on is a wrapper around the official [Actual Budget](https://github.com/actualbudget/actual) Docker image to make it work as a Home Assistant add-on.

Actual Budget — Local-first personal finance app  
Copyright (C) James Long

Licensed under the [MIT License](LICENSE).
