const repo = require('../repositories/pembayaran-pembelian.repository');
const pembelianRepo = require('../repositories/pembelian.repository');

exports.getByPembelianId = function (pembelianId) { return repo.findByPembelianId(pembelianId); };
exports.getUnpaid = function () { return repo.findUnpaidPembelian(); };

exports.create = async function (data) {
  if (!data.pembelian_id)
    throw Object.assign(new Error('Pembelian harus dipilih'), { status: 400 });
  if (!data.jumlah_bayar || parseFloat(data.jumlah_bayar) <= 0)
    throw Object.assign(new Error('Jumlah bayar harus lebih dari 0'), { status: 400 });

  const pembelian = await pembelianRepo.findById(data.pembelian_id);
  if (!pembelian)
    throw Object.assign(new Error('Pembelian tidak ditemukan'), { status: 400 });

  return repo.create(data);
};

exports.del = function (id) { return repo.del(id); };
