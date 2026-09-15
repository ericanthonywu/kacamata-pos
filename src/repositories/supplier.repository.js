const db = require('../config/database');
const TABLE = 'supplier';

exports.findAll = function (cabangId = null) {
  let q = db(TABLE);
  if (cabangId) q = q.where('cabang_id', cabangId);
  return q.orderBy('nama', 'asc');
};

exports.findById = function (id) { return db(TABLE).where('id', id).first(); };
exports.create = function (data) { return db(TABLE).insert(data).returning('*').then(r => r[0]); };
exports.update = function (id, data) { return db(TABLE).where('id', id).update(data).returning('*').then(r => r[0]); };
