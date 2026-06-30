const db = require('../config/database');
const pembelianReturRepo = require('../repositories/pembelian-retur.repository');
const pembelianReturDetailRepo = require('../repositories/pembelian-retur-detail.repository');
const pembelianRepo = require('../repositories/pembelian.repository');
const barangRepo = require('../repositories/barang.repository');
const { todayStr } = require('../utils/date.helper');

exports.getAll = function () { return pembelianReturRepo.findAll(); };

exports.getById = async function (id) {
  const retur = await pembelianReturRepo.findById(id);
  if (!retur) return null;
  const detail = await pembelianReturDetailRepo.findByReturId(id);
  return { ...retur, detail };
};

exports.create = async function (data) {
  if (!data.pembelian_id)
    throw Object.assign(new Error('Pembelian harus dipilih'), { status: 400 });

  const pembelian = await pembelianRepo.findById(data.pembelian_id);
  if (!pembelian)
    throw Object.assign(new Error('Pembelian tidak ditemukan'), { status: 400 });

  const items = (data.items || []).filter(i => i.barang_id && parseInt(i.jumlah) > 0);
  if (items.length === 0)
    throw Object.assign(new Error('Minimal satu item harus diisi'), { status: 400 });

  let total_retur = 0;
  for (const item of items) {
    total_retur += (parseFloat(item.harga_beli) || 0) * (parseInt(item.jumlah) || 1);
  }

  const kode_retur = await pembelianReturRepo.generateKodeRetur();

  const returData = {
    kode_retur,
    pembelian_id: data.pembelian_id,
    tanggal_retur: data.tanggal_retur || todayStr(),
    total_retur,
  };

  const retur = await db.transaction(async (trx) => {
    // 1. Insert retur
    const retur = await pembelianReturRepo.insert(trx, returData);

    // 2. Insert details and decrement stock (items returned to supplier)
    const detailRows = items.map(item => ({
      pembelian_retur_id: retur.id,
      barang_id: item.barang_id,
      jumlah: item.jumlah || 1,
      harga_beli: item.harga_beli || 0,
    }));
    await pembelianReturDetailRepo.insertMany(trx, detailRows);

    for (const item of items) {
      if (item.barang_id) {
        await barangRepo.decrementQty(item.barang_id, item.jumlah || 1, trx);
      }
    }

    return retur;
  });

  return exports.getById(retur.id);
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    // 1. Revert stock
    const details = await pembelianReturDetailRepo.findRawByReturId(trx, id);
    for (const item of details) {
      if (item.barang_id) {
        await barangRepo.incrementQty(item.barang_id, item.jumlah, trx);
      }
    }

    // 2. Delete details and retur
    await pembelianReturDetailRepo.deleteByReturId(trx, id);
    await pembelianReturRepo.deleteById(trx, id);
  });
};
