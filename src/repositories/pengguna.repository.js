const db = require('../config/database');
const TABLE = 'pengguna';

const SAFE_COLS = ['pengguna.id', 'pengguna.nama', 'pengguna.username', 'pengguna.hak_akses', 'pengguna.cabang_id', 'pengguna.created_at'];

exports.findAll = function (cabangId) {
  let q = db(TABLE)
    .leftJoin('cabang', 'pengguna.cabang_id', 'cabang.id')
    .select(SAFE_COLS)
    .select('cabang.nama as cabang_nama');
  if (cabangId) q = q.where('pengguna.cabang_id', cabangId);
  return q.orderBy('pengguna.nama', 'asc');
};

exports.findById = function (id) {
  return db(TABLE)
    .leftJoin('cabang', 'pengguna.cabang_id', 'cabang.id')
    .select(SAFE_COLS)
    .select('cabang.nama as cabang_nama')
    .where('pengguna.id', id)
    .first();
};

exports.findByUsernameAndCabang = function (username, cabangId) {
  return db(TABLE)
    .leftJoin('cabang', 'pengguna.cabang_id', 'cabang.id')
    .select('pengguna.*', 'cabang.nama as cabang_nama')
    .where({ 'pengguna.username': username, 'pengguna.cabang_id': cabangId })
    .first();
};

exports.create = function (data) {
  return db(TABLE).insert(data).returning(SAFE_COLS).then(r => r[0]);
};

exports.update = function (id, data) {
  return db(TABLE).where('id', id).update(data).returning(SAFE_COLS).then(r => r[0]);
};

exports.del = function (id) {
  return db(TABLE).where('id', id).del();
};
