// ESLint configuration for Node.js 24 / ES2024+
module.exports = [
  {
    files: ['src/**/*.js', 'db/**/*.js', 'knexfile.js'],
    languageOptions: {
      ecmaVersion: 2024,
      sourceType: 'commonjs',
    },
  },
];
