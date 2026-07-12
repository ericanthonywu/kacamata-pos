'use strict';
// Runs automatically after `npm install` (npm "prepare" script). Points git at
// the committed .githooks directory so the pre-commit lint guard is active for
// every clone — no extra dependency (e.g. husky) required. No-op outside a git
// checkout (CI/tarball installs) so it can never break `npm install`.
const fs = require('fs');
const { execSync } = require('child_process');

if (!fs.existsSync('.git')) process.exit(0);

try {
  execSync('git config core.hooksPath .githooks', { stdio: 'ignore' });
} catch (err) {
  // Hooks are a dev convenience; never fail the install over them.
}
