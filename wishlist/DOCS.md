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

Leave **empty** (recommended). SvelteKit’s Node adapter then infers the site URL per request from **`X-Forwarded-Host`** and **`X-Forwarded-Proto`** (set by Caddy from the browser-facing `Host` / scheme, or from an outer reverse proxy). That keeps form submissions and CSRF checks working whether you use **Home Assistant ingress**, a **public domain**, or **http://&lt;ip&gt;:3280**.

Set a single full `http://` or `https://` URL only if you intentionally **pin** one public base URL (for example a single reverse proxy hostname) and do not rely on multiple ways to open the same instance.

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

#### HA ingress (family) + public domain (anonymous) at the same time

It is **one** add-on and **one** global `header_auth_enabled` flag. You cannot turn header auth on only for ingress in config — instead:

1. Set **`header_auth_enabled` to `true`**. In Home Assistant, open Wishlist from the side panel: Supervisor injects the HA user headers and Wishlist can log in household members without a separate password (subject to the [user matching rules](#header-authentication-ha-ingress-sso) above).
2. Publish **`https://wishlist.example.com` (or your domain) through Nginx Proxy Manager (or any reverse proxy) to the add-on’s host port (e.g. `http://&lt;ha&gt;:3280`)** and make sure **the public vhost does not pass identity headers to Wishlist**. In NPM, use **Custom Nginx Configuration** (e.g. on the *Advanced* tab) so the proxy **overwrites** the headers to empty *before* the request goes to the add-on, for example:

   ```nginx
   proxy_set_header X-Remote-User-Name "";
   proxy_set_header X-Remote-User-Display-Name "";
   proxy_set_header X-Remote-User-Id "";
   proxy_set_header X-Remote-Email "";
   ```

   If you changed `header_username`, `header_name`, or `header_email` in the add-on, clear **those** header names instead (and still clear `X-Remote-User-Id` if the upstream [Wishlist](https://github.com/cmintey/wishlist) reads it for SSO).

3. This way **ingress** = headers present = SSO; **public URL** = headers stripped = visitors only see the normal login / signup (anonymous until they use Wishlist accounts). Anyone on the internet could try to *send* fake headers; **you must** overwrite them on the public proxy (as above), not only “remove from defaults”, so clients cannot spoof a HA user on the public hostname.

4. Keep **`origin` empty** so CSRF and URLs work for both the HA URL and your domain (see [origin](#origin-optional)). Leave the add-on’s port mapped only on your internal network, or put the same hostname rules behind a firewall as you prefer.

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
- The **upstream** Wishlist image runs **Caddy** on **3280** in the container and reverse-proxies to the SvelteKit server on **3000** (see [Caddyfile](https://github.com/cmintey/wishlist) and `docker-compose` `3280:3280`). The add-on maps **`3280/tcp: 3280`**. **Ingress** must use `ingress_port: 3280` (Caddy), not 3000 — the Supervisor has to hit the same front door as a browser, not the internal Node port.
- Do **not** set `PORT=3280` in add-on options: that would make Node try to listen on 3280 and break the Caddy → `:3000` setup.
- This add-on **replaces** `/usr/src/app/Caddyfile` with a small patch: **`servers { trusted_proxies static private_ranges }`**. Home Assistant’s Supervisor is another hop in front of Caddy; without trusting proxy ranges, Caddy overwrites `X-Forwarded-Proto` / `X-Forwarded-*`, while Wishlist’s `entrypoint.sh` sets `HOST_HEADER` / `PROTOCOL_HEADER` for SvelteKit — that mismatch often shows up as **404** in the iframe, even though `http://<ip>:3280` works in a new tab.
