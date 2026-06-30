const db = require('../config/database');
const TABLE = 'pembayaran_penjualan';

exports.findByPenjualanId = function (penjualanId) {
  return db(TABLE)
    .select('pembayaran_penjualan.*', 'metode_pembayaran.nama as metode_pembayaran_nama')
    .leftJoin('metode_pembayaran', 'pembayaran_penjualan.metode_bayar_id', 'metode_pembayaran.id')
    .where('penjualan_id', penjualanId)
    .orderBy('tanggal_bayar', 'asc')
    .orderBy('pembayaran_penjualan.id', 'asc');
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

exports.deleteByPenjualanId = function (trx, penjualanId) {
  return trx(TABLE).where('penjualan_id', penjualanId).del();
};

exports.sumByPenjualanId = function (trx, penjualanId) {
  return (trx || db)(TABLE)
    .where('penjualan_id', penjualanId)
    .sum('jumlah_bayar as total')
    .first();
};

exports.findUnpaidPenjualan = function (query = {}) {
  let q = db('penjualan')
    .select(
      'penjualan.*',
      'pelanggan.nama as pelanggan_nama',
      db.raw('COALESCE((SELECT SUM(jumlah_bayar) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id), 0) as total_dibayar')
    )
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .whereIn('penjualan.status_bayar', ['dp', 'belum_lunas']);

  if (query.start_date) q = q.where('penjualan.order_date', '>=', query.start_date);
  if (query.end_date) q = q.where('penjualan.order_date', '<=', query.end_date);

  return q.orderBy('penjualan.created_at', 'desc');
};

exports.updateMetodeBayarWhereNull = function (trx, penjualanId, metodeBayarId) {
  return trx(TABLE).where('penjualan_id', penjualanId).whereNull('metode_bayar_id').update({ metode_bayar_id: metodeBayarId });
};
