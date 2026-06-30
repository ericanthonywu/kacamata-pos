const db = require('../config/database');
const pembayaranRepo = require('../repositories/pembayaran-pembelian.repository');
const pembelianRepo = require('../repositories/pembelian.repository');
const { todayStr } = require('../utils/date.helper');

exports.getByPembelianId = function (pembelianId) { return pembayaranRepo.findByPembelianId(pembelianId); };
exports.getUnpaid = function (query) { return pembayaranRepo.findUnpaidPembelian(query); };

exports.create = async function (data) {
  if (!data.pembelian_id)
    throw Object.assign(new Error('Pembelian harus dipilih'), { status: 400 });
  if (!data.jumlah_bayar || parseFloat(data.jumlah_bayar) <= 0)
    throw Object.assign(new Error('Jumlah bayar harus lebih dari 0'), { status: 400 });

  const pembelian = await pembelianRepo.findById(data.pembelian_id);
  if (!pembelian)
    throw Object.assign(new Error('Pembelian tidak ditemukan'), { status: 400 });

  return db.transaction(async (trx) => {
    // 1. Insert payment
    const payment = await pembayaranRepo.insert(trx, {
      pembelian_id: data.pembelian_id,
      tanggal_bayar: data.tanggal_bayar || todayStr(),
      jumlah_bayar: data.jumlah_bayar,
      keterangan: data.keterangan || '',
    });

    // 2. Check total paid and update status
    const totalPaid = await pembayaranRepo.sumByPembelianId(trx, data.pembelian_id);
    const newStatus = parseFloat(totalPaid.total) >= parseFloat(pembelian.total_harga) ? 'lunas' : 'belum_lunas';
    await pembelianRepo.update(trx, data.pembelian_id, { status_bayar: newStatus, updated_at: new Date() });

    return payment;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    const payment = await pembayaranRepo.findById(trx, id);
    if (!payment) return;

    // 1. Delete payment
    await pembayaranRepo.deleteById(trx, id);

    // 2. Recalculate status
    const totalPaid = await pembayaranRepo.sumByPembelianId(trx, payment.pembelian_id);
    const pembelian = await pembelianRepo.findByIdWithTrx(trx, payment.pembelian_id);
    const newStatus = parseFloat(totalPaid.total || 0) >= parseFloat(pembelian.total_harga) ? 'lunas' : 'belum_lunas';
    await pembelianRepo.update(trx, payment.pembelian_id, { status_bayar: newStatus, updated_at: new Date() });
  });
};
