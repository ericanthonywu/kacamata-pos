const knex = require('knex');
const config = require('../../knexfile');

const db = knex(config);

// Enhance Knex connection validation to immediately discard stale/dead sockets
if (db.client) {
  const originalValidate = db.client.validateConnection.bind(db.client);
  db.client.validateConnection = function (connection) {
    if (!connection) return false;
    if (connection.__knex__disposed) return false;
    if (connection._ending || connection._ended) return false;
    const stream = connection.connection?.stream;
    if (stream && (stream.destroyed || !stream.writable || !stream.readable)) {
      return false;
    }
    return originalValidate(connection);
  };
}

module.exports = db;
