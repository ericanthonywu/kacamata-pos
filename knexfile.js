require('dotenv').config();
const { pickReachableAddress } = require('./src/config/resolve-host');

const HOST = process.env.DB_HOST || 'localhost';
const PORT = parseInt(process.env.DB_PORT || '5432');

module.exports = {
  client: 'pg',
  connection: async () => ({
    host: await pickReachableAddress(HOST, PORT),
    port: PORT,
    database: process.env.DB_NAME || 'kacamata_pos',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || '',
    keepAlive: true,
    keepAliveInitialDelayMillis: 10000,
    connectionTimeoutMillis: 10000,
    query_timeout: 30000,
  }),
  pool: { min: 0, max: 10, idleTimeoutMillis: 30000, reapIntervalMillis: 10000 },
  migrations: {
    directory: './db/migrations',
  },
  seeds: {
    directory: './db/seeds',
  },
};
