const db = require('../config/database');

exports.findByPenjualanId = function (penjualanId) {
  return db('pembayaran_penjualan')
    .where('penjualan_id', penjualanId)
    .orderBy('tanggal_bayar', 'asc');
};

exports.create = async function (data) {
  return db.transaction(async (trx) => {
    const [payment] = await trx('pembayaran_penjualan').insert({
      penjualan_id: data.penjualan_id,
      tanggal_bayar: data.tanggal_bayar || new Date().toISOString().split('T')[0],
      jumlah_bayar: data.jumlah_bayar,
      keterangan: data.keterangan || '',
    }).returning('*');

    // Check total paid and update status
    const totalPaid = await trx('pembayaran_penjualan')
      .where('penjualan_id', data.penjualan_id)
      .sum('jumlah_bayar as total')
      .first();
    const penjualan = await trx('penjualan').where('id', data.penjualan_id).first();
    const newStatus = parseFloat(totalPaid.total) >= parseFloat(penjualan.total) ? 'lunas' : 'dp';
    await trx('penjualan').where('id', data.penjualan_id).update({ status_bayar: newStatus });

    return payment;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    const payment = await trx('pembayaran_penjualan').where('id', id).first();
    if (!payment) return;
    await trx('pembayaran_penjualan').where('id', id).del();

    // Recalculate status
    const totalPaid = await trx('pembayaran_penjualan')
      .where('penjualan_id', payment.penjualan_id)
      .sum('jumlah_bayar as total')
      .first();
    const penjualan = await trx('penjualan').where('id', payment.penjualan_id).first();
    const paid = parseFloat(totalPaid.total || 0);
    let newStatus = 'dp';
    if (paid >= parseFloat(penjualan.total)) newStatus = 'lunas';
    else if (paid === 0) newStatus = penjualan.dp > 0 ? 'dp' : 'belum_lunas';
    await trx('penjualan').where('id', payment.penjualan_id).update({ status_bayar: newStatus });
  });
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
