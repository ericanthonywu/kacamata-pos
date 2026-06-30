const db = require('../config/database');
const pembayaranRepo = require('../repositories/pembayaran-penjualan.repository');
const penjualanRepo = require('../repositories/penjualan.repository');
const penjualanDetailRepo = require('../repositories/penjualan-detail.repository');
const kasRepo = require('../repositories/kas.repository');
const komisiSalesRepo = require('../repositories/komisi-sales.repository');
const salesRepo = require('../repositories/sales.repository');
const { buildKomisiRows } = require('../utils/komisi.helper');
const { todayStr } = require('../utils/date.helper');

exports.getByPenjualanId = function (penjualanId) { return pembayaranRepo.findByPenjualanId(penjualanId); };
exports.getUnpaid = function (query) { return pembayaranRepo.findUnpaidPenjualan(query); };

exports.create = async function (data) {
  if (!data.penjualan_id)
    throw Object.assign(new Error('Penjualan harus dipilih'), { status: 400 });
  if (!data.jumlah_bayar || parseFloat(data.jumlah_bayar) <= 0)
    throw Object.assign(new Error('Jumlah bayar harus lebih dari 0'), { status: 400 });

  const penjualan = await penjualanRepo.findById(data.penjualan_id);
  if (!penjualan)
    throw Object.assign(new Error('Penjualan tidak ditemukan'), { status: 400 });

  return db.transaction(async (trx) => {
    // 1. Insert payment
    const payment = await pembayaranRepo.insert(trx, {
      penjualan_id: data.penjualan_id,
      tanggal_bayar: data.tanggal_bayar || todayStr(),
      jumlah_bayar: data.jumlah_bayar,
      keterangan: data.keterangan || '',
      metode_bayar_id: data.metode_bayar_id || null,
    });

    // 2. Check total paid and update status
    const totalPaid = await pembayaranRepo.sumByPenjualanId(trx, data.penjualan_id);
    const newStatus = parseFloat(totalPaid.total) >= parseFloat(penjualan.total) ? 'lunas' : 'dp';
    await penjualanRepo.update(trx, data.penjualan_id, { status_bayar: newStatus });

    // 3. Record in kas ledger
    let kategori = 'pelunasan';
    if (payment.keterangan === 'Pembayaran lunas') kategori = 'pembayaran_lunas';
    else if (payment.keterangan === 'Down Payment') kategori = 'down_payment';
    await kasRepo.insert(trx, {
      tipe: 'masuk',
      kategori,
      jumlah: payment.jumlah_bayar,
      tanggal: payment.tanggal_bayar,
      referensi_id: payment.id,
      referensi_tipe: 'pembayaran_penjualan',
      penjualan_id: data.penjualan_id,
      no_referensi: penjualan.no_nota,
      keterangan: payment.keterangan || '',
      metode_bayar_id: data.metode_bayar_id || null,
    });

    // 4. Handle komisi if it just became lunas
    if (newStatus === 'lunas' && penjualan.status_bayar !== 'lunas' && penjualan.sales_id) {
      const detailItems = await penjualanDetailRepo.findRawByPenjualanId(penjualan.id, trx);
      const sales = await salesRepo.findById(penjualan.sales_id);
      if (sales) {
        const komisiRows = buildKomisiRows(penjualan.id, sales, detailItems);
        await komisiSalesRepo.insertMany(trx, komisiRows);
      }
    }

    return payment;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    const payment = await pembayaranRepo.findById(trx, id);
    if (!payment) return;

    // 1. Delete payment
    await pembayaranRepo.deleteById(trx, id);

    // 2. Remove from kas ledger
    await kasRepo.deleteByRef(trx, id, 'pembayaran_penjualan');

    // 3. Recalculate status
    const totalPaid = await pembayaranRepo.sumByPenjualanId(trx, payment.penjualan_id);
    const penjualan = await penjualanRepo.findByIdWithTrx(trx, payment.penjualan_id);
    const paid = parseFloat(totalPaid.total || 0);
    let newStatus = 'dp';
    if (paid >= parseFloat(penjualan.total)) newStatus = 'lunas';
    else if (paid === 0) newStatus = penjualan.dp > 0 ? 'dp' : 'belum_lunas';
    await penjualanRepo.update(trx, payment.penjualan_id, { status_bayar: newStatus });

    // 4. Revert komisi if it's no longer lunas
    if (penjualan.status_bayar === 'lunas' && newStatus !== 'lunas') {
      await komisiSalesRepo.deleteByPenjualanId(trx, penjualan.id);
    }
  });
};
