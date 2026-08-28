const db = require('../config/database');
const TABLE = 'pelanggan';

exports.findAll = function () { return db(TABLE).orderBy('nama', 'asc'); };
exports.findById = function (id) { return db(TABLE).where('id', id).first(); };
exports.findByName = function (nama) { return db(TABLE).where('nama', 'ilike', nama).first(); };
exports.findByNameAndPhone = function (nama, no_telp) {
  const q = db(TABLE).where('nama', 'ilike', nama);
  if (no_telp) {
    return q.where('no_telp', no_telp).first();
  }
  return q.where(function () {
    this.whereNull('no_telp').orWhere('no_telp', '');
  }).first();
};
exports.search = function (q) {
  return db(TABLE)
    .where('nama', 'ilike', `%${q}%`)
    .orWhere('no_telp', 'ilike', `%${q}%`)
    .orderBy('nama', 'asc').limit(20);
};
exports.create = function (data) { return db(TABLE).insert(data).returning('*').then(r => r[0]); };
exports.update = function (id, data) { return db(TABLE).where('id', id).update(data).returning('*').then(r => r[0]); };
