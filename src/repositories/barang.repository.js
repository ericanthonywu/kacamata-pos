const db = require('../config/database');
const TABLE = 'barang';

exports.findAll = function () {
  return db(TABLE)
    .select('barang.*', 'kategori.nama as kategori_nama')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .orderBy('barang.nama_barang', 'asc');
};

exports.findById = function (id) {
  return db(TABLE)
    .select('barang.*', 'kategori.nama as kategori_nama')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .where('barang.id', id)
    .first();
};

exports.search = function (q) {
  return db(TABLE)
    .select('barang.*', 'kategori.nama as kategori_nama')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .where('barang.nama_barang', 'ilike', `%${q}%`)
    .orWhere('barang.barcode_id', 'ilike', `%${q}%`)
    .orderBy('barang.nama_barang', 'asc')
    .limit(20);
};

exports.create = function (data) {
  return db(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.update = function (id, data) {
  data.updated_at = db.fn.now();
  return db(TABLE).where('id', id).update(data).returning('*').then(r => r[0]);
};

exports.del = function (id) {
  return db(TABLE).where('id', id).del();
};

exports.decrementQty = function (id, amount) {
  return db(TABLE).where('id', id).decrement('qty', amount);
};

exports.incrementQty = function (id, amount) {
  return db(TABLE).where('id', id).increment('qty', amount);
};
