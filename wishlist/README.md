# Wishlist Home Assistant Add-on

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

This add-on runs [Wishlist](https://github.com/cmintey/wishlist) inside Home Assistant OS.

Wishlist is a self-hosted shareable wishlist application. You no longer have to wonder what to get your family for the holidays — simply check their wishlist and claim any available item.

Wishlist version: 0.63.0

## Features

- Claim and purchase items on a wishlist
- Automatically fetch product data from a URL
- Multiple groups (friends, family, etc.)
- Registry Mode with a public shareable link
- PWA support
- OAuth / OpenID Connect authentication
- Optional header-based proxy authentication

## Installation

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fborucsan%2Fha-addons)

Install the **Wishlist** add-on from this repository and start it.

## Configuration

| Option | Default | Description |
|---|---|---|
| `timezone` | `UTC` | Container timezone (TZ env var) |
| `origin` | — | Full URL users connect to (leave empty for ingress) |
| `token_time` | `72` | Hours until signup/reset tokens expire |
| `default_currency` | `USD` | Global default currency (ISO code) |
| `max_image_size` | `5000000` | Max image upload size in bytes |
| `header_auth_enabled` | `false` | Enable header-based proxy authentication |
| `header_username` | — | Header name carrying the username |
| `header_name` | — | Header name carrying the full name |
| `header_email` | — | Header name carrying the email |

## Persistent storage

All data survives add-on updates and reinstalls:

- **Database** (`prod.db`) → stored in addon_config at `/config/data/`
- **Image uploads** → stored in addon_config at `/config/uploads/`

## Disclaimers and copyright information

This add-on is a wrapper around the official [Wishlist](https://github.com/cmintey/wishlist) Docker image to make it work as a Home Assistant add-on.

Wishlist — Self-hosted shareable wishlist  
Copyright (C) cmintey  
MIT License
