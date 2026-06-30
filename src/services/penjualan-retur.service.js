const db = require('../config/database');
const penjualanReturRepo = require('../repositories/penjualan-retur.repository');
const penjualanReturDetailRepo = require('../repositories/penjualan-retur-detail.repository');
const penjualanRepo = require('../repositories/penjualan.repository');
const penjualanDetailRepo = require('../repositories/penjualan-detail.repository');
const kasRepo = require('../repositories/kas.repository');
const komisiSalesRepo = require('../repositories/komisi-sales.repository');
const salesRepo = require('../repositories/sales.repository');
const barangRepo = require('../repositories/barang.repository');
const { buildKomisiRows } = require('../utils/komisi.helper');
const { todayStr } = require('../utils/date.helper');

exports.getAll = function () { return penjualanReturRepo.findAll(); };

exports.getById = async function (id) {
  const retur = await penjualanReturRepo.findById(id);
  if (!retur) return null;
  const detail = await penjualanReturDetailRepo.findByReturId(id);
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

  const kode_retur = await penjualanReturRepo.generateKodeRetur();

  const returData = {
    kode_retur,
    penjualan_id: data.penjualan_id,
    tanggal_retur: data.tanggal_retur || todayStr(),
    total_retur,
  };

  const retur = await db.transaction(async (trx) => {
    // 1. Insert retur
    const retur = await penjualanReturRepo.insert(trx, returData);

    // 2. Insert details and increment stock (items returned from customer)
    const detailRows = items.map(item => ({
      penjualan_retur_id: retur.id,
      barang_id: item.barang_id,
      tipe: item.tipe || 'frame',
      jumlah: item.jumlah || 1,
      harga: item.harga || 0,
    }));
    await penjualanReturDetailRepo.insertMany(trx, detailRows);

    for (const item of items) {
      if (item.barang_id) {
        await barangRepo.incrementQty(item.barang_id, item.jumlah || 1, trx);
      }
    }

    // 3. Remove original transaction from kas ledger
    await kasRepo.deleteByPenjualanId(trx, returData.penjualan_id);

    // 4. Delete komisi sales (penjualan has been returned)
    await komisiSalesRepo.deleteByPenjualanId(trx, returData.penjualan_id);

    return retur;
  });

  return exports.getById(retur.id);
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    // Get penjualan_id before deleting
    const retur = await penjualanReturRepo.findById(id);
    const penjualanId = retur ? retur.penjualan_id : null;

    // 1. Revert stock from retur details
    const details = await penjualanReturDetailRepo.findRawByReturIds(trx, [id]);
    for (const item of details) {
      if (item.barang_id) {
        await barangRepo.decrementQty(item.barang_id, item.jumlah, trx);
      }
    }

    // 2. (Kas is not restored automatically; original kas was deleted on retur creation)

    // 3. Delete details and retur
    await penjualanReturDetailRepo.deleteByReturId(trx, id);
    await penjualanReturRepo.deleteById(trx, id);

    // 4. Restore komisi sales after retur is deleted
    if (penjualanId) {
      const penjualan = await penjualanRepo.findByIdWithTrx(trx, penjualanId);
      if (penjualan && penjualan.status_bayar === 'lunas' && penjualan.sales_id) {
        const sales = await salesRepo.findById(penjualan.sales_id);
        if (sales) {
          const detailItems = await penjualanDetailRepo.findRawByPenjualanId(penjualanId, trx);
          await komisiSalesRepo.deleteByPenjualanId(trx, penjualanId);
          const komisiRows = buildKomisiRows(penjualanId, sales, detailItems);
          await komisiSalesRepo.insertMany(trx, komisiRows);
        }
      }
    }
  });
};
