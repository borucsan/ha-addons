/**
 * HA Ingress base-path patch.
 * Injected before any other scripts so that all fetch(), XHR, WebSocket and
 * history calls automatically include the ingress prefix regardless of how the
 * URL was constructed (literal string, template literal, or variable).
 *
 * `location` itself cannot be patched, so nginx rewrites `location.pathname`
 * and `location.href = ` in Koffan's own scripts to `__haLoc.*` (defined below),
 * which hides the prefix on read and adds it on navigation.
 *
 * When the addon is accessed directly (not via ingress) __haLoc behaves like
 * plain `location` and nothing else is patched.
 */
(function () {
    // Detect ingress base from the page URL, e.g. /api/hassio_ingress/TOKEN
    var parts = window.location.pathname.split('/api/hassio_ingress/');
    var token = parts.length > 1 ? parts[1].split('/')[0] : '';
    var base  = token ? '/api/hassio_ingress/' + token : '';

    function hasBase(p) {
        return p === base || p.indexOf(base + '/') === 0 || p.indexOf(base + '?') === 0;
    }

    // Idempotent: URLs that already carry the ingress prefix are left alone.
    function fix(u) {
        if (!base || typeof u !== 'string') return u;
        // Absolute path starting with / (but not //)
        if (u.charAt(0) === '/' && (u.length < 2 || u.charAt(1) !== '/')) {
            return hasBase(u) ? u : base + u;
        }
        // Absolute same-origin URL: https://host/path, wss://host/path, ...
        var h = '://' + window.location.host;
        var i = u.indexOf(h + '/');
        if (i !== -1) {
            var p = u.slice(i + h.length);
            return hasBase(p) ? u : u.slice(0, i + h.length) + base + p;
        }
        return u;
    }

    // Koffan matches routes like /lists/5 against location.pathname and
    // navigates with location.href = '/lists/5'.
    window.__haLoc = {
        get pathname() {
            var p = window.location.pathname;
            return base && hasBase(p) ? (p.slice(base.length) || '/') : p;
        },
        get href() { return window.location.href; },
        set href(u) { window.location.href = fix(u); }
    };

    if (!base) return;

    // Koffan 2.14 registers a PWA service worker with scope '/' and caches
    // absolute /static/* URLs. That cannot work under HA ingress (wrong origin
    // path and a scope broader than the script URL). Disable it here.
    if (navigator.serviceWorker) {
        navigator.serviceWorker.register = function () {
            return Promise.reject(new Error('Service worker disabled under HA ingress'));
        };
        if (navigator.serviceWorker.getRegistrations) {
            navigator.serviceWorker.getRegistrations().then(function (regs) {
                regs.forEach(function (r) { r.unregister(); });
            });
        }
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

    // Patch history (offline list URLs are swapped for /lists/ID after sync)
    ['pushState', 'replaceState'].forEach(function (name) {
        var orig = history[name];
        history[name] = function (state, title, url) {
            if (arguments.length > 2) arguments[2] = fix(url);
            return orig.apply(this, arguments);
        };
    });

    // Patch WebSocket constructor (real-time updates)
    // Koffan builds the URL as: `${protocol}//${window.location.host}/ws`
    var _WebSocket = window.WebSocket;
    window.WebSocket = function (u, p) {
        return p !== undefined ? new _WebSocket(fix(u), p) : new _WebSocket(fix(u));
    };
    window.WebSocket.prototype = _WebSocket.prototype;
})();
