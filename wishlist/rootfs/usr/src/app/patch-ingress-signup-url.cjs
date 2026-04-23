/**
 * Upstream (v0.63.x) signup page runs:
 *   onMount: if (data.valid) window.history.replaceState({}, "", "/signup");
 * That rewrites the browser URL to path "/signup" on the *host* root, not under
 * /api/hassio_ingress/... — so the next POST goes to https://&lt;ha&gt;/signup (core), not
 * the add-on. Strip only this replaceState() call from the built client JS.
 */
"use strict";
const fs = require("node:fs");
const path = require("node:path");

const buildDir = path.join("/usr/src/app", "build");
if (!fs.existsSync(buildDir)) {
	console.log("patch-ingress-signup-url: no build/ directory, skip");
	process.exit(0);
}

// Third argument must be the root-relative "/signup" that breaks ingress
const patterns = [
	[/window\.history\.replaceState\(\s*\{\s*\}\s*,\s*""\s*,\s*"\/signup"\s*\)/g, "void 0"],
	[/window\.history\.replaceState\(\s*\{\s*\}\s*,\s*''\s*,\s*'\/signup'\s*\)/g, "void 0"],
	[/history\.replaceState\(\s*\{\s*\}\s*,\s*""\s*,\s*"\/signup"\s*\)/g, "void 0"],
	[/history\.replaceState\(\s*\{\s*\}\s*,\s*''\s*,\s*'\/signup'\s*\)/g, "void 0"],
];

function listJsFiles(dir, out = []) {
	for (const name of fs.readdirSync(dir, { withFileTypes: true })) {
		const p = path.join(dir, name.name);
		if (name.isDirectory()) listJsFiles(p, out);
		else if (/\.(js|mjs)$/.test(p)) out.push(p);
	}
	return out;
}

const files = listJsFiles(buildDir);
let patched = 0;
for (const f of files) {
	let s = fs.readFileSync(f, "utf8");
	if (!s.includes("replaceState") || !s.includes("signup")) continue;
	const before = s;
	for (const [re, rep] of patterns) s = s.replace(re, rep);
	if (s !== before) {
		fs.writeFileSync(f, s);
		patched++;
	}
}
console.log("patch-ingress-signup-url: patched " + patched + " file(s)");
if (patched === 0) {
	console.warn(
		"patch-ingress-signup-url: 0 client bundles changed — if signup POST hits /signup on the HA host, upstream Wishlist may have changed; open an issue on the add-on or upgrade patch patterns."
	);
}
