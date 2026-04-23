# Home Assistant Add-on: Wishlist

Wishlist is a self-hosted shareable wishlist application for friends and family.

## How to use

1. Install the add-on.
2. (Optional) Set `timezone` in the add-on configuration, e.g. `Europe/Warsaw`.
3. Start the add-on.
4. Open Wishlist from the add-on page using **Open Web UI**.
5. Complete the first-run setup wizard to create the initial admin account.

## Configuration

### `timezone` (default: `UTC`)

Timezone passed to the container as the `TZ` environment variable.

### `origin` (optional)

The URL users connect to, e.g. `https://wishlist.example.com` or `http://192.168.1.10:3000`. Leave **empty** for the default (recommended): the add-on reads the ingress path from the Supervisor, loads your Home Assistant **external / internal** URL from Core, and sets `ORIGIN` to a full `https://…/api/hassio_ingress/…` value so the SvelteKit app can load `/_app` assets. This requires the add-on’s `homeassistant_api` permission (granted in this repository) so the container can call `/core/api/config` once at startup.

Set a full `http://` or `https://` URL here only if you **do not** use ingress (for example you open Wishlist only via the mapped host port or an external reverse proxy at a known URL).

### `token_time` (default: `72`)

Hours until signup and password-reset tokens expire.

### `default_currency` (default: `USD`)

Global default currency (ISO code). Can still be changed per item.

### `max_image_size` (default: `5000000`)

Maximum image upload size in bytes (default 5 MB).

## Header Authentication (HA Ingress SSO)

When Wishlist is accessed through the HA ingress, the Supervisor automatically injects the following headers for every authenticated request:

| Header | Content |
|---|---|
| `X-Remote-User-Name` | HA username |
| `X-Remote-User-Display-Name` | HA display name |
| `X-Remote-User-Id` | HA user ID |

With `header_auth_enabled: true` and the pre-filled default header names, Wishlist will automatically log in the visiting HA user — no separate Wishlist password needed.

> **Important — first-time user provisioning:** Wishlist can auto-create new accounts via header auth, but only when an email header is also provided. Because HA Supervisor does not inject an email header, **auto-registration will not work**. The practical flow is:
> 1. The first admin account must be created through the **setup wizard** (normal registration).
> 2. Any additional users should be created in Wishlist first (via invite or signup), using a username that **exactly matches** their HA username.
> 3. Once the account exists in Wishlist, header auth will log them in automatically on every ingress visit.
>
> Alternatively, set `header_email` to a custom header if your setup provides one (e.g. from Authentik or Authelia via a custom reverse proxy on the exposed port).

> **Security notice:** When header authentication is enabled, Wishlist trusts the headers unconditionally. The HA Supervisor enforces HA authentication before forwarding requests, so using ingress is safe. Exposing the add-on port directly without a trusted proxy while header auth is enabled is **not recommended**.

### `header_auth_enabled` (default: `false`)

Enable header-based authentication. Set to `true` to use HA Ingress SSO.

### `header_username` (default: `X-Remote-User-Name`)

Name of the HTTP header that contains the username.

### `header_name` (default: `X-Remote-User-Display-Name`)

Name of the HTTP header that contains the user's full name.

### `header_email` (default: empty)

Name of the HTTP header that contains the user's email address. Leave empty when using native HA ingress (auto-registration will be skipped; existing users still log in automatically).

## Notes

- Data is stored persistently in addon_config: `data/` (SQLite database) and `uploads/` (user images).
- The add-on uses ingress by default with SSE streaming enabled for real-time list events.
- A host port (`3000`) is also exposed for API access or external proxy use.
