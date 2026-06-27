const repo = require('../repositories/bukti-hitung-fisik.repository');
const barangRepo = require('../repositories/barang.repository');
const db = require('../config/database');

exports.create = function (data) {
  if (!data.nama_barang) throw Object.assign(new Error('Nama barang harus diisi'), { status: 400 });
  return repo.create({
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

  // Use transaction to ensure atomicity
  return db.transaction(async (trx) => {
    // Update barang stock
    await trx('barang').where('id', data.barang_id).update({ qty: qtySesudah, updated_at: trx.fn.now() });

    // Create BHF log
    const [log] = await trx('bukti_hitung_fisik').insert({
      barang_id: data.barang_id,
      nama_barang: barang.nama_barang,
      barcode_id: barang.barcode_id || '',
      qty_sebelum: qtySebelum,
      qty_sesudah: qtySesudah,
      selisih,
      diubah_oleh: data.diubah_oleh || '',
    }).returning('*');

    return log;
  });
};

exports.getDatatablesData = function (params) {
  return repo.getDatatablesData(params);
};

exports.del = async function (id) {
  const log = await repo.findById(id);
  if (!log) throw Object.assign(new Error('Data tidak ditemukan'), { status: 404 });
  await repo.del(id);
  return log;
};
