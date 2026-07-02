const db = require('../config/database');
const bhfRepo = require('../repositories/bukti-hitung-fisik.repository');
const barangRepo = require('../repositories/barang.repository');

exports.create = function (data) {
  if (!data.nama_barang) throw Object.assign(new Error('Nama barang harus diisi'), { status: 400 });
  return bhfRepo.create({
    barang_id: data.barang_id,
    nama_barang: data.nama_barang,
    barcode_id: data.barcode_id || '',
    qty_sebelum: parseInt(data.qty_sebelum) || 0,
    qty_sesudah: parseInt(data.qty_sesudah) || 0,
    selisih: (parseInt(data.qty_sesudah) || 0) - (parseInt(data.qty_sebelum) || 0),
    diubah_oleh: data.diubah_oleh || '',
  });
};

/**
 * Create a BHF log entry AND update the barang stock in a transaction.
 * Used by the manual "Tambah" form on the BHF page.
 */
exports.createWithStockUpdate = async function (data) {
  if (!data.barang_id) throw Object.assign(new Error('Barang harus dipilih'), { status: 400 });

  const barang = await barangRepo.findById(data.barang_id);
  if (!barang) throw Object.assign(new Error('Barang tidak ditemukan'), { status: 404 });

  const qtySebelum = barang.qty !== null ? parseInt(barang.qty) : 0;
  const qtySesudah = parseInt(data.qty_sesudah);
  if (isNaN(qtySesudah)) throw Object.assign(new Error('Qty sesudah harus diisi'), { status: 400 });

  const selisih = qtySesudah - qtySebelum;

  return db.transaction(async (trx) => {
    // Update barang stock
    await barangRepo.updateQty(trx, data.barang_id, qtySesudah);

    // Create BHF log
    const log = await bhfRepo.insertWithTrx(trx, {
      barang_id: data.barang_id,
      nama_barang: barang.nama_barang,
      barcode_id: barang.barcode_id || '',
      qty_sebelum: qtySebelum,
      qty_sesudah: qtySesudah,
      selisih,
      diubah_oleh: data.diubah_oleh || '',
    });

    return log;
  });
};

exports.getDatatablesData = function (params) {
  return bhfRepo.getDatatablesData(params);
};

exports.createBulkWithStockUpdate = async function (items, diubahOleh) {
  if (!items || items.length === 0) {
    throw Object.assign(new Error('Minimal satu item harus diisi'), { status: 400 });
  }

  // Validate all items first
  const barangDataMap = {};
  for (const item of items) {
    if (!item.barang_id) {
      throw Object.assign(new Error('Semua baris harus memilih barang'), { status: 400 });
    }
    const qtySesudah = parseInt(item.qty_sesudah);
    if (isNaN(qtySesudah)) {
      throw Object.assign(new Error('Qty sesudah harus diisi untuk semua baris'), { status: 400 });
    }
    if (!barangDataMap[item.barang_id]) {
      const barang = await barangRepo.findById(item.barang_id);
      if (!barang) {
        throw Object.assign(new Error(`Barang dengan ID ${item.barang_id} tidak ditemukan`), { status: 404 });
      }
      barangDataMap[item.barang_id] = barang;
    }
  }

  return db.transaction(async (trx) => {
    const logs = [];

    for (const item of items) {
      const barang = barangDataMap[item.barang_id];
      const qtySebelum = barang.qty !== null ? parseInt(barang.qty) : 0;
      const qtySesudah = parseInt(item.qty_sesudah);
      const selisih = qtySesudah - qtySebelum;

      // Update barang stock
      await barangRepo.updateQty(trx, item.barang_id, qtySesudah);

      // Create BHF log
      const log = await bhfRepo.insertWithTrx(trx, {
        barang_id: item.barang_id,
        nama_barang: barang.nama_barang,
        barcode_id: barang.barcode_id || '',
        qty_sebelum: qtySebelum,
        qty_sesudah: qtySesudah,
        selisih,
        diubah_oleh: diubahOleh || '',
      });

      logs.push(log);

      // Update in-memory data so subsequent same-barang entries use the new qty
      barang.qty = qtySesudah;
    }

    return logs;
  });
};

exports.del = async function (id) {
  const log = await bhfRepo.findById(id);
  if (!log) throw Object.assign(new Error('Data tidak ditemukan'), { status: 404 });
  await bhfRepo.del(id);
  return log;
};
