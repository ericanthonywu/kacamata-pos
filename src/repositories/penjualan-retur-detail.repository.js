const db = require('../config/database');
const TABLE = 'penjualan_retur_detail';

exports.findByReturId = function (returId) {
  return db(TABLE)
    .select('penjualan_retur_detail.*', 'barang.nama_barang', 'barang.barcode_id')
    .leftJoin('barang', 'penjualan_retur_detail.barang_id', 'barang.id')
    .where('penjualan_retur_detail.penjualan_retur_id', returId)
    .orderBy('penjualan_retur_detail.id', 'asc');
};

exports.findRawByReturIds = function (trx, returIds) {
  return (trx || db)(TABLE).whereIn('penjualan_retur_id', returIds);
};

exports.insertMany = function (trx, rows) {
  if (!rows.length) return Promise.resolve();
  return trx(TABLE).insert(rows);
};

exports.deleteByReturId = function (trx, returId) {
  return trx(TABLE).where('penjualan_retur_id', returId).del();
};

exports.deleteByReturIds = function (trx, returIds) {
  if (!returIds.length) return Promise.resolve();
  return trx(TABLE).whereIn('penjualan_retur_id', returIds).del();
};
