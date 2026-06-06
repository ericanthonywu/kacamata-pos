const repo = require('../repositories/pembayaran-penjualan.repository');
const penjualanRepo = require('../repositories/penjualan.repository');

exports.getByPenjualanId = function (penjualanId) { return repo.findByPenjualanId(penjualanId); };
exports.getUnpaid = function () { return repo.findUnpaidPenjualan(); };

exports.create = async function (data) {
  if (!data.penjualan_id)
    throw Object.assign(new Error('Penjualan harus dipilih'), { status: 400 });
  if (!data.jumlah_bayar || parseFloat(data.jumlah_bayar) <= 0)
    throw Object.assign(new Error('Jumlah bayar harus lebih dari 0'), { status: 400 });

  const penjualan = await penjualanRepo.findById(data.penjualan_id);
  if (!penjualan)
    throw Object.assign(new Error('Penjualan tidak ditemukan'), { status: 400 });

  return repo.create(data);
};

exports.del = function (id) { return repo.del(id); };
