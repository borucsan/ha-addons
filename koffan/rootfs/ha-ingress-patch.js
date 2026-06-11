/**
 * HA Ingress base-path patch.
 * Injected before any other scripts so that all fetch(), XHR and WebSocket
 * calls automatically include the ingress prefix regardless of how the URL
 * was constructed (literal string, template literal, or variable).
 *
 * When the addon is accessed directly (not via ingress) the script exits
 * immediately without patching anything.
 */
(function () {
    // Detect ingress base from the page URL, e.g. /api/hassio_ingress/TOKEN
    var parts = window.location.pathname.split('/api/hassio_ingress/');
    var token = parts.length > 1 ? parts[1].split('/')[0] : '';
    var base  = token ? '/api/hassio_ingress/' + token : '';
    if (!base) return;

    function fix(u) {
        if (typeof u !== 'string') return u;
        // Absolute path starting with / (but not //)
        if (u.charAt(0) === '/' && (u.length < 2 || u.charAt(1) !== '/')) {
            return base + u;
        }
        // Absolute same-origin WebSocket URL: wss://host/path or ws://host/path
        var h = window.location.host;
        if (u.indexOf('://' + h + '/') !== -1) {
            return u.replace('://' + h + '/', '://' + h + base + '/');
        }
        return u;
    }

    // Patch window.fetch (used by Alpine.js components)
    var _fetch = window.fetch;
    window.fetch = function (u, o) {
        return _fetch.call(this, fix(u), o);
    };

    // Patch XMLHttpRequest.open (used by htmx)
    var _xhrOpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function (method, url) {
        arguments[1] = fix(url);
        return _xhrOpen.apply(this, arguments);
    };

    // Patch WebSocket constructor (real-time updates)
    // Koffan builds the URL as: `${protocol}//${window.location.host}/ws`
    var _WebSocket = window.WebSocket;
    window.WebSocket = function (u, p) {
        return p !== undefined ? new _WebSocket(fix(u), p) : new _WebSocket(fix(u));
    };
    window.WebSocket.prototype = _WebSocket.prototype;
})();
