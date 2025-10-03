const fs = require('fs');
const path = require('path');

const ROOT = process.cwd();
const DISALLOWED = [/anju100959389/i, /anju-100959389/i];
// Ignore folders that should not be scanned and the scripts folder (to avoid self-matching)
const IGNORE_DIRS = new Set(['.git', 'node_modules', '.vscode', '.idea', 'scripts']);

function scan(dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const e of entries) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) {
      if (!IGNORE_DIRS.has(e.name)) scan(p);
    } else if (e.isFile()) {
      try {
        const content = fs.readFileSync(p, 'utf8');
        for (const rx of DISALLOWED) {
          if (rx.test(content)) {
            console.error(`Disallowed pattern ${rx} found in: ${path.relative(ROOT, p)}`);
            process.exitCode = 1;
          }
        }
      } catch {
        /* skip unreadable files */
      }
    }
  }
}

scan(ROOT);
if (process.exitCode === 1) {
  console.error('\nERROR: Disallowed names detected. Please replace with hushng-101012042 or hushng-101012042-service as appropriate.');
  process.exit(1);
} else {
  console.log('Name check passed.');
}
