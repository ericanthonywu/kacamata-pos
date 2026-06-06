const db = require('../config/database');

exports.findAll = function () {
  return db('penjualan_retur')
    .select('penjualan_retur.*', 'penjualan.no_nota', 'pelanggan.nama as pelanggan_nama')
    .leftJoin('penjualan', 'penjualan_retur.penjualan_id', 'penjualan.id')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .orderBy('penjualan_retur.created_at', 'desc');
};

exports.findById = function (id) {
  return db('penjualan_retur')
    .select('penjualan_retur.*', 'penjualan.no_nota', 'pelanggan.nama as pelanggan_nama')
    .leftJoin('penjualan', 'penjualan_retur.penjualan_id', 'penjualan.id')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .where('penjualan_retur.id', id).first();
};

exports.findDetailsByReturId = function (returId) {
  return db('penjualan_retur_detail')
    .select('penjualan_retur_detail.*', 'barang.nama_barang', 'barang.barcode_id')
    .leftJoin('barang', 'penjualan_retur_detail.barang_id', 'barang.id')
    .where('penjualan_retur_detail.penjualan_retur_id', returId)
    .orderBy('penjualan_retur_detail.id', 'asc');
};

exports.create = async function (returData, detailItems) {
  return db.transaction(async (trx) => {
    const [retur] = await trx('penjualan_retur').insert(returData).returning('*');
    for (const item of detailItems) {
      await trx('penjualan_retur_detail').insert({
        penjualan_retur_id: retur.id,
        barang_id: item.barang_id,
        tipe: item.tipe || 'frame',
        jumlah: item.jumlah || 1,
        harga: item.harga || 0,
      });
      // Increment stock (items returned from customer)
      if (item.barang_id) {
        await trx('barang').where('id', item.barang_id).increment('qty', item.jumlah || 1);
      }
    }
    return retur;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    const details = await trx('penjualan_retur_detail').where('penjualan_retur_id', id);
    for (const item of details) {
      if (item.barang_id) {
        await trx('barang').where('id', item.barang_id).decrement('qty', item.jumlah);
      }
    }
    await trx('penjualan_retur').where('id', id).del();
  });
};

exports.generateKodeRetur = async function () {
  const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const prefix = `RJ-${today}-`;
  const result = await db('penjualan_retur').where('kode_retur', 'like', `${prefix}%`).count('id as cnt').first();
  const seq = (parseInt(result.cnt) || 0) + 1;
  return prefix + String(seq).padStart(4, '0');
};
