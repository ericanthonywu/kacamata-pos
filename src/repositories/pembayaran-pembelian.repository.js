const db = require('../config/database');

exports.findByPembelianId = function (pembelianId) {
  return db('pembayaran_pembelian')
    .where('pembelian_id', pembelianId)
    .orderBy('tanggal_bayar', 'asc');
};

exports.create = async function (data) {
  return db.transaction(async (trx) => {
    const [payment] = await trx('pembayaran_pembelian').insert({
      pembelian_id: data.pembelian_id,
      tanggal_bayar: data.tanggal_bayar || new Date().toISOString().split('T')[0],
      jumlah_bayar: data.jumlah_bayar,
      keterangan: data.keterangan || '',
    }).returning('*');

    // Check total paid and update status
    const totalPaid = await trx('pembayaran_pembelian')
      .where('pembelian_id', data.pembelian_id)
      .sum('jumlah_bayar as total')
      .first();
    const pembelian = await trx('pembelian').where('id', data.pembelian_id).first();
    const newStatus = parseFloat(totalPaid.total) >= parseFloat(pembelian.total_harga) ? 'lunas' : 'belum_lunas';
    await trx('pembelian').where('id', data.pembelian_id).update({ status_bayar: newStatus, updated_at: new Date() });

    return payment;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    const payment = await trx('pembayaran_pembelian').where('id', id).first();
    if (!payment) return;
    await trx('pembayaran_pembelian').where('id', id).del();

    // Recalculate status
    const totalPaid = await trx('pembayaran_pembelian')
      .where('pembelian_id', payment.pembelian_id)
      .sum('jumlah_bayar as total')
      .first();
    const pembelian = await trx('pembelian').where('id', payment.pembelian_id).first();
    const newStatus = parseFloat(totalPaid.total || 0) >= parseFloat(pembelian.total_harga) ? 'lunas' : 'belum_lunas';
    await trx('pembelian').where('id', payment.pembelian_id).update({ status_bayar: newStatus, updated_at: new Date() });
  });
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
