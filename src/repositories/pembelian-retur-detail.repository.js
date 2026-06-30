const db = require('../config/database');
const TABLE = 'pembelian_retur_detail';

exports.findByReturId = function (returId) {
  return db(TABLE)
    .select('pembelian_retur_detail.*', 'barang.nama_barang', 'barang.barcode_id')
    .leftJoin('barang', 'pembelian_retur_detail.barang_id', 'barang.id')
    .where('pembelian_retur_detail.pembelian_retur_id', returId)
    .orderBy('pembelian_retur_detail.id', 'asc');
};

exports.findRawByReturId = function (trx, returId) {
  return (trx || db)(TABLE).where('pembelian_retur_id', returId);
};

exports.insertMany = function (trx, rows) {
  if (!rows.length) return Promise.resolve();
  return trx(TABLE).insert(rows);
};

exports.deleteByReturId = function (trx, returId) {
  return trx(TABLE).where('pembelian_retur_id', returId).del();
};
