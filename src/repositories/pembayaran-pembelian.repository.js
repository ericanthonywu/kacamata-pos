const db = require('../config/database');
const TABLE = 'pembayaran_pembelian';

exports.findByPembelianId = function (pembelianId) {
  return db(TABLE)
    .where('pembelian_id', pembelianId)
    .orderBy('tanggal_bayar', 'asc');
};

exports.insert = function (trx, data) {
  return trx(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.findById = function (trx, id) {
  return (trx || db)(TABLE).where('id', id).first();
};

exports.deleteById = function (trx, id) {
  return trx(TABLE).where('id', id).del();
};

exports.sumByPembelianId = function (trx, pembelianId) {
  return (trx || db)(TABLE)
    .where('pembelian_id', pembelianId)
    .sum('jumlah_bayar as total')
    .first();
};

exports.findUnpaidPembelian = function (query = {}) {
  let q = db('pembelian')
    .select(
      'pembelian.*',
      'supplier.nama as supplier_nama',
      db.raw('COALESCE((SELECT SUM(jumlah_bayar) FROM pembayaran_pembelian WHERE pembelian_id = pembelian.id), 0) as total_dibayar')
    )
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id')
    .where('pembelian.status_bayar', 'belum_lunas');

  if (query.start_date) q = q.where('pembelian.tanggal_pembelian', '>=', query.start_date);
  if (query.end_date) q = q.where('pembelian.tanggal_pembelian', '<=', query.end_date);

  return q.orderBy('pembelian.created_at', 'desc');
};
