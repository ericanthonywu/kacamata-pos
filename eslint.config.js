// Guard for the Node 13 / Windows 7 deployment target (last Node that runs on
// Win7). Server code must stay ES2019-compatible: optional chaining (?.),
// nullish coalescing (??), and logical assignment (||= &&= ??=) are ES2020+ /
// Node 14+ and would be a parse-time SyntaxError on the Win7 box. Pinning the
// parser to ecmaVersion 2019 turns any such syntax into a lint failure on the
// (modern) dev machine, before it ever ships. Run: `npm run lint`.
//
// Only Node-executed code is guarded. Browser code under public/ is not linted
// here — it runs in Chrome, not Node 13, so modern syntax there is fine.
//
// Minor trade-off: a few features Node 13 *does* support (BigInt literals `10n`,
// numeric separators `1_000`) are also flagged as ES2020+; rewrite them if hit.
module.exports = [
  {
    files: ['src/**/*.js', 'db/**/*.js', 'knexfile.js'],
    languageOptions: {
      ecmaVersion: 2019,
      sourceType: 'commonjs',
    },
  },
];
