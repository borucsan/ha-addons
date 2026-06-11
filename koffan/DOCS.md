# Home Assistant Add-on: Koffan

Koffan is a free, self-hosted groceries list for families and shared households, available directly in Home Assistant.

## How to use

1. Install the add-on.
2. Set `app_password` in add-on configuration to a secure password.
3. (Optional) Set `timezone`, `default_lang`, and other options.
4. Start the add-on.
5. Open Koffan from the sidebar using the **Koffan** panel entry.

## Configuration

### `app_password` (required)

Login password for the Koffan web interface. Change from the default `changeme` before first use.

### `disable_auth`

Set to `true` to disable Koffan's built-in authentication. Useful when running behind a reverse proxy that handles authentication. Defaults to `false`.

### `default_lang`

Default UI language on first load. Supported values: `pl`, `en`, `de`, `es`, `fr`, `pt`, `uk`, `no`, `lt`, `el`, `sk`, `ru`. Defaults to `en`.

### `api_token`

Enable the REST API by setting a secret token. Leave empty to disable the API. See [Koffan REST API docs](https://github.com/PanSalut/Koffan/wiki/REST-API) for details.

### `timezone`

Timezone passed to the container (TZ environment variable). Defaults to `UTC`.

## Notes

- Shopping list data is stored in the addon_config directory and persists across restarts and updates.
- The add-on uses Home Assistant ingress for the sidebar panel.
