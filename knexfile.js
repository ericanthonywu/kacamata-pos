require('dotenv').config();

module.exports = {
  client: 'pg',
  connection: {
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '5432'),
    database: process.env.DB_NAME || 'kacamata_pos',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || '',
  },
  pool: { min: 2, max: 10 },
  migrations: {
    directory: './db/migrations',
  },
  seeds: {
    directory: './db/seeds',
  },
};
