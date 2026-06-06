const repo = require('../repositories/penjualan-retur.repository');
const penjualanRepo = require('../repositories/penjualan.repository');

exports.getAll = function () { return repo.findAll(); };

exports.getById = async function (id) {
  const retur = await repo.findById(id);
  if (!retur) return null;
  const detail = await repo.findDetailsByReturId(id);
  return { ...retur, detail };
};

exports.create = async function (data) {
  if (!data.penjualan_id)
    throw Object.assign(new Error('Penjualan harus dipilih'), { status: 400 });

  const penjualan = await penjualanRepo.findById(data.penjualan_id);
  if (!penjualan)
    throw Object.assign(new Error('Penjualan tidak ditemukan'), { status: 400 });

  const items = (data.items || []).filter(i => i.barang_id && parseInt(i.jumlah) > 0);
  if (items.length === 0)
    throw Object.assign(new Error('Minimal satu item harus diisi'), { status: 400 });

  let total_retur = 0;
  for (const item of items) {
    total_retur += (parseFloat(item.harga) || 0) * (parseInt(item.jumlah) || 1);
  }

  const kode_retur = await repo.generateKodeRetur();

  const returData = {
    kode_retur,
    penjualan_id: data.penjualan_id,
    tanggal_retur: data.tanggal_retur || new Date().toISOString().split('T')[0],
    total_retur,
  };

  const retur = await repo.create(returData, items);
  return exports.getById(retur.id);
};

exports.del = function (id) { return repo.del(id); };
