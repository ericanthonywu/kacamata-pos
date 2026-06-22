const db = require('../config/database');
const TABLE = 'metode_pembayaran';

exports.findAll = function ({ includeDeleted = false } = {}) {
  let q = db(TABLE).orderBy('id', 'asc');
  if (!includeDeleted) q = q.whereNull('deleted_at');
  return q;
};

exports.findById = function (id) {
  return db(TABLE).where('id', id).first();
};

exports.create = function (data) {
  return db(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.update = function (id, data) {
  return db(TABLE).where('id', id).update(data).returning('*').then(r => r[0]);
};

exports.del = function (id) {
  return db(TABLE).where('id', id).update({ deleted_at: new Date() });
};
