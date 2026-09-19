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
    connectionTimeoutMillis: parseInt(process.env.DB_CONNECTION_TIMEOUT || '60000', 10),
    query_timeout: parseInt(process.env.DB_QUERY_TIMEOUT || '120000', 10),
    statement_timeout: parseInt(process.env.DB_STATEMENT_TIMEOUT || '120000', 10),
  }),
  pool: {
    min: 0,
    max: 10,
    acquireTimeoutMillis: 60000,
    createTimeoutMillis: 60000,
    idleTimeoutMillis: 60000,
    reapIntervalMillis: 10000,
  },
  migrations: {
    directory: './db/migrations',
  },
  seeds: {
    directory: './db/seeds',
  },
};
