/**
 * Stitch MCP proxy wrapper
 * Workaround for stitch-mcp v0.5.1 bug where process.exit(0)
 * kills the MCP server before it can handle any requests.
 *
 * Instead of using the CLI (which calls process.exit), we import
 * the proxy directly and keep the process alive.
 */

// Prevent any process.exit calls from killing the server
const originalExit = process.exit;
let serverStarted = false;

process.exit = (code) => {
  if (serverStarted && code === 0) {
    // Suppress process.exit(0) after server starts — keep alive for MCP
    return;
  }
  originalExit(code);
};

// Dynamically import the stitch-mcp package
const pkgPath = await import('child_process')
  .then(cp => cp.execSync('npm root -g', { encoding: 'utf-8' }).trim())
  .catch(() => null);

// Use npx-cached version
import { pathToFileURL } from 'node:url';
import { execSync } from 'node:child_process';
import { existsSync } from 'node:fs';
import { join } from 'node:path';

// Find the cached stitch-mcp package
const npmCachePath = join(process.env.LOCALAPPDATA || '', 'npm-cache', '_npx');
let stitchPath = null;

// Search in npx cache
if (existsSync(npmCachePath)) {
  const { readdirSync } = await import('node:fs');
  for (const dir of readdirSync(npmCachePath)) {
    const candidate = join(npmCachePath, dir, 'node_modules', '@_davideast', 'stitch-mcp');
    if (existsSync(candidate)) {
      stitchPath = candidate;
      break;
    }
  }
}

if (!stitchPath) {
  // Ensure it's installed
  execSync('npx -y @_davideast/stitch-mcp@0.5.1 --version', { stdio: 'ignore' });
  // Try again
  if (existsSync(npmCachePath)) {
    const { readdirSync } = await import('node:fs');
    for (const dir of readdirSync(npmCachePath)) {
      const candidate = join(npmCachePath, dir, 'node_modules', '@_davideast', 'stitch-mcp');
      if (existsSync(candidate)) {
        stitchPath = candidate;
        break;
      }
    }
  }
}

if (!stitchPath) {
  console.error('[wrapper] Could not find stitch-mcp package');
  originalExit(1);
}

// Import the proxy chunk directly
const proxyChunkPath = join(stitchPath, 'dist', 'chunk-kw62yeqn.js');
const coreChunkPath = join(stitchPath, 'dist', 'chunk-0cd2xak4.js');

const { ProxyCommandHandler } = await import(pathToFileURL(proxyChunkPath).href);

serverStarted = true;

const handler = new ProxyCommandHandler();
const result = await handler.execute({
  debug: false
});

if (!result.success) {
  console.error(`[wrapper] Proxy error: ${result.error?.message}`);
  originalExit(1);
}

// Keep alive — the event loop stays active via stdin listeners
