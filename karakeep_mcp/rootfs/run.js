#!/usr/bin/env node
/** Run Karakeep's stdio-only MCP server over Streamable HTTP.
 *
 * Reads /data/options.json, waits for Karakeep to answer, then starts
 * supergateway: stdio (karakeep-mcp) -> Streamable HTTP (/mcp) on :8766.
 * supergateway also enforces the bearer token (SUPERGATEWAY_API_KEY).
 */
"use strict";

const { spawn } = require("node:child_process");
const fs = require("node:fs");

const OPTIONS_PATH = "/data/options.json";
const MIN_TOKEN_LENGTH = 16;
const KARAKEEP_WAIT_MS = 5 * 60 * 1000;
const KARAKEEP_RETRY_MS = 5 * 1000;
const KARAKEEP_TIMEOUT_MS = 5 * 1000;
const PORT = 8766;

function log(level, message, ...args) {
  console.error(`[karakeep-mcp] ${level}: ${message}`, ...args);
}

function fail(message) {
  log("ERROR", message);
  process.exit(1);
}

function loadOptions() {
  let options;
  try {
    options = JSON.parse(fs.readFileSync(OPTIONS_PATH, "utf8"));
  } catch (error) {
    fail(`cannot read ${OPTIONS_PATH}: ${error.message}`);
  }

  const str = (key) => (options[key] == null ? "" : String(options[key]).trim());

  const token = str("auth_token");
  if (token.length < MIN_TOKEN_LENGTH) {
    fail(
      `auth_token must be at least ${MIN_TOKEN_LENGTH} characters ` +
        "(e.g. generate one with `openssl rand -hex 32`)"
    );
  }

  const addr = str("karakeep_api_addr").replace(/\/+$/, "");
  if (!addr) fail("karakeep_api_addr is required");

  const apiKey = str("karakeep_api_key");
  if (!apiKey) fail("karakeep_api_key is required");

  let customHeaders = "";
  const rawHeaders = str("custom_headers");
  if (rawHeaders) {
    try {
      const parsed = JSON.parse(rawHeaders);
      if (parsed === null || typeof parsed !== "object" || Array.isArray(parsed)) {
        fail("custom_headers must be a JSON object");
      }
      customHeaders = JSON.stringify(parsed);
    } catch (error) {
      fail(`custom_headers is not valid JSON: ${error.message}`);
    }
  }

  return {
    addr,
    apiKey,
    customHeaders,
    token,
    logLevel: str("log_level") || "info",
  };
}

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function waitForKarakeep({ addr, apiKey, customHeaders }) {
  const url = `${addr}/api/v1/bookmarks?limit=1`;
  const headers = { Authorization: `Bearer ${apiKey}` };
  if (customHeaders) Object.assign(headers, JSON.parse(customHeaders));

  const deadline = Date.now() + KARAKEEP_WAIT_MS;
  for (;;) {
    try {
      const response = await fetch(url, {
        headers,
        signal: AbortSignal.timeout(KARAKEEP_TIMEOUT_MS),
      });
      if (response.ok || response.status === 400) return;
      if (response.status === 401 || response.status === 403) {
        fail(`${addr} rejected the API key / custom headers (HTTP ${response.status})`);
      }
      return; // Reachable; let the tools report any other API problem.
    } catch (error) {
      if (Date.now() >= deadline) {
        fail(`Karakeep at ${addr} is unreachable: ${error.message}`);
      }
      log(
        "WARNING",
        `Karakeep at ${addr} is not reachable yet (${error.message}), ` +
          `retrying in ${KARAKEEP_RETRY_MS / 1000}s`
      );
      await sleep(KARAKEEP_RETRY_MS);
    }
  }
}

function main() {
  const options = loadOptions();

  waitForKarakeep(options)
    .then(() => {
      const env = {
        ...process.env,
        KARAKEEP_API_ADDR: options.addr,
        KARAKEEP_API_KEY: options.apiKey,
        KARAKEEP_CUSTOM_HEADERS: options.customHeaders,
        SUPERGATEWAY_API_KEY: options.token,
      };

      const args = [
        "--stdio", "karakeep-mcp",
        "--outputTransport", "streamableHttp",
        "--stateful",
        "--host", "0.0.0.0",
        "--port", String(PORT),
        "--streamableHttpPath", "/mcp",
        "--healthEndpoint", "/healthz",
        "--logLevel", options.logLevel,
      ];

      log("INFO", `Serving Karakeep MCP (Streamable HTTP) on http://0.0.0.0:${PORT}/mcp`);
      const child = spawn("supergateway", args, {
        env,
        // A closed stdin pipe makes supergateway exit, so ignore it.
        stdio: ["ignore", "inherit", "inherit"],
      });

      for (const signal of ["SIGTERM", "SIGINT"]) {
        process.on(signal, () => child.kill(signal));
      }
      child.on("error", (error) => fail(`cannot start supergateway: ${error.message}`));
      child.on("exit", (code, signal) => process.exit(code ?? (signal ? 1 : 0)));
    })
    .catch((error) => fail(`startup failed: ${error.message}`));
}

main();
