require('dotenv').config();

const HOST = process.env.DB_HOST || 'localhost';
const PORT = parseInt(process.env.DB_PORT || '5432', 10);

module.exports = {
  client: 'pg',
  connection: {
    host: HOST,
    port: PORT,
    database: process.env.DB_NAME || 'kacamata_pos',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || '',
    keepAlive: true,
    keepAliveInitialDelayMillis: 5000,
    connectionTimeoutMillis: parseInt(process.env.DB_CONNECTION_TIMEOUT || '30000', 10),
    query_timeout: parseInt(process.env.DB_QUERY_TIMEOUT || '45000', 10),
    statement_timeout: parseInt(process.env.DB_STATEMENT_TIMEOUT || '45000', 10),
  },
  pool: {
    min: 2,
    max: 10,
    acquireTimeoutMillis: 30000,
    createTimeoutMillis: 30000,
    idleTimeoutMillis: 30000,
    reapIntervalMillis: 10000,
    afterCreate: (conn, done) => {
      conn.query("SET idle_in_transaction_session_timeout = '60000'", (err) => {
        done(err, conn);
      });
    },
  },
  migrations: {
    directory: './db/migrations',
  },
  seeds: {
    directory: './db/seeds',
  },
};
