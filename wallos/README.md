# Wallos Home Assistant Add-on

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

This add-on runs [Wallos](https://github.com/ellite/Wallos) inside Home Assistant OS.

Wallos is an open-source, self-hosted personal subscription tracker.  
Wallos version: 4.6.2

## Installation

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fborucsan%2Fha-addons)

Install the **Wallos** add-on from this repository and start it.

## Configuration

- **timezone** (default: `UTC`)
  - Timezone used by the Wallos container, e.g. `Europe/Warsaw`.

## API Access

Wallos exposes a REST API under `/api/`. To use it from a Home Assistant integration or external tool:

1. Set a host port in the add-on network configuration (default: `8282`).
2. Generate an API key in Wallos → **Settings → API**.
3. Call the API at `http://homeassistant.local:8282/api/` with the `Authorization: Bearer <key>` header.

## Disclaimers and copyright information

This add-on is a wrapper around the official [Wallos](https://github.com/ellite/Wallos) Docker image to make it work as a Home Assistant add-on.

Wallos — Open-Source Personal Subscription Tracker  
Copyright (C) ellite

This program comes with ABSOLUTELY NO WARRANTY.
