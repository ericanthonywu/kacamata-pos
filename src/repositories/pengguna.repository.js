const db = require('../config/database');
const TABLE = 'pengguna';

const SAFE_COLS = ['id', 'nama', 'username', 'hak_akses', 'created_at'];

exports.findAll = function () { return db(TABLE).select(SAFE_COLS).orderBy('nama', 'asc'); };
exports.findById = function (id) { return db(TABLE).select(SAFE_COLS).where('id', id).first(); };
exports.findByUsername = function (username) { return db(TABLE).where('username', username).first(); };
exports.create = function (data) { return db(TABLE).insert(data).returning(SAFE_COLS).then(r => r[0]); };
exports.update = function (id, data) { return db(TABLE).where('id', id).update(data).returning(SAFE_COLS).then(r => r[0]); };
exports.del = function (id) { return db(TABLE).where('id', id).del(); };
