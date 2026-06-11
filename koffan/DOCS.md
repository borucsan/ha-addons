# Home Assistant Add-on: Koffan

Koffan is a free, self-hosted groceries list for families and shared households, available directly in Home Assistant.

## How to use

1. Install the add-on.
2. (Optional) Set `timezone`, `default_lang`, and other options.
3. Start the add-on.
4. Open Koffan from the sidebar using the **Koffan** panel entry.

## Authentication

Koffan's built-in login is disabled automatically — Home Assistant ingress already requires users to be logged into HA before they can reach the add-on.

### `default_lang`

Default UI language on first load. Supported values: `pl`, `en`, `de`, `es`, `fr`, `pt`, `uk`, `no`, `lt`, `el`, `sk`, `ru`. Defaults to `en`.

### `api_token`

Enable the REST API by setting a secret token. Leave empty to disable the API. See [Koffan REST API docs](https://github.com/PanSalut/Koffan/wiki/REST-API) for details.

### `timezone`

Timezone passed to the container (TZ environment variable). Defaults to `UTC`.

## Notes

- Shopping list data is stored in the addon_config directory and persists across restarts and updates.
- The add-on uses Home Assistant ingress for the sidebar panel.
