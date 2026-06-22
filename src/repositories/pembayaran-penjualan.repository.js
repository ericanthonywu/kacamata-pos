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

    // Record in kas ledger
    let kategori = 'pelunasan';
    if (payment.keterangan === 'Pembayaran lunas') kategori = 'pembayaran_lunas';
    else if (payment.keterangan === 'Down Payment') kategori = 'down_payment';
    await trx('kas').insert({
      tipe: 'masuk',
      kategori,
      jumlah: payment.jumlah_bayar,
      tanggal: payment.tanggal_bayar,
      referensi_id: payment.id,
      referensi_tipe: 'pembayaran_penjualan',
      penjualan_id: data.penjualan_id,
      no_referensi: penjualan.no_nota,
      keterangan: payment.keterangan || '',
    });

    // Handle komisi if it just became lunas
    if (newStatus === 'lunas' && penjualan.status_bayar !== 'lunas' && penjualan.sales_id) {
      const detailItems = await trx('penjualan_detail').where('penjualan_id', penjualan.id);
      var frameTotal = 0, lensaTotal = 0;
      for (var j = 0; j < detailItems.length; j++) {
        var line = detailItems[j];
        var lineTotal = (parseFloat(line.harga || 0) - parseFloat(line.diskon || 0)) * parseInt(line.jumlah || 1);
        if (line.tipe === 'frame') frameTotal += lineTotal;
        else if (line.tipe === 'lensa_r' || line.tipe === 'lensa_l') lensaTotal += lineTotal;
      }
      var sales = await trx('sales').where('id', penjualan.sales_id).first();
      if (sales) {
        var komisiRows = [];
        if (frameTotal > 0 && parseFloat(sales.komisi_frame) > 0) {
          komisiRows.push({
            penjualan_id: penjualan.id, sales_id: sales.id, tipe: 'frame',
            persentase: sales.komisi_frame, nominal_komisi: frameTotal * parseFloat(sales.komisi_frame) / 100
          });
        }
        if (lensaTotal > 0 && parseFloat(sales.komisi_lensa) > 0) {
          komisiRows.push({
            penjualan_id: penjualan.id, sales_id: sales.id, tipe: 'lensa',
            persentase: sales.komisi_lensa, nominal_komisi: lensaTotal * parseFloat(sales.komisi_lensa) / 100
          });
        }
        if (komisiRows.length > 0) await trx('komisi_sales').insert(komisiRows);
      }
    }

    return payment;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    const payment = await trx('pembayaran_penjualan').where('id', id).first();
    if (!payment) return;
    await trx('pembayaran_penjualan').where('id', id).del();

    // Remove from kas ledger
    await trx('kas')
      .where('referensi_id', id)
      .where('referensi_tipe', 'pembayaran_penjualan')
      .del();

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

    // Revert komisi if it's no longer lunas
    if (penjualan.status_bayar === 'lunas' && newStatus !== 'lunas') {
      await trx('komisi_sales').where('penjualan_id', penjualan.id).del();
    }
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
