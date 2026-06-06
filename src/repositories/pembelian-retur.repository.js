const db = require('../config/database');

exports.findAll = function () {
  return db('pembelian_retur')
    .select('pembelian_retur.*', 'pembelian.kode_pembelian', 'supplier.nama as supplier_nama')
    .leftJoin('pembelian', 'pembelian_retur.pembelian_id', 'pembelian.id')
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id')
    .orderBy('pembelian_retur.created_at', 'desc');
};

exports.findById = function (id) {
  return db('pembelian_retur')
    .select('pembelian_retur.*', 'pembelian.kode_pembelian', 'supplier.nama as supplier_nama')
    .leftJoin('pembelian', 'pembelian_retur.pembelian_id', 'pembelian.id')
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id')
    .where('pembelian_retur.id', id).first();
};

exports.findDetailsByReturId = function (returId) {
  return db('pembelian_retur_detail')
    .select('pembelian_retur_detail.*', 'barang.nama_barang', 'barang.barcode_id')
    .leftJoin('barang', 'pembelian_retur_detail.barang_id', 'barang.id')
    .where('pembelian_retur_detail.pembelian_retur_id', returId)
    .orderBy('pembelian_retur_detail.id', 'asc');
};

exports.create = async function (returData, detailItems) {
  return db.transaction(async (trx) => {
    const [retur] = await trx('pembelian_retur').insert(returData).returning('*');
    for (const item of detailItems) {
      await trx('pembelian_retur_detail').insert({
        pembelian_retur_id: retur.id,
        barang_id: item.barang_id,
        jumlah: item.jumlah || 1,
        harga_beli: item.harga_beli || 0,
      });
      if (item.barang_id) {
        await trx('barang').where('id', item.barang_id).decrement('qty', item.jumlah || 1);
      }
    }
    return retur;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    const details = await trx('pembelian_retur_detail').where('pembelian_retur_id', id);
    for (const item of details) {
      if (item.barang_id) {
        await trx('barang').where('id', item.barang_id).increment('qty', item.jumlah);
      }
    }
    await trx('pembelian_retur').where('id', id).del();
  });
};

exports.generateKodeRetur = async function () {
  const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const prefix = `RPI-${today}-`;
  const result = await db('pembelian_retur').where('kode_retur', 'like', `${prefix}%`).count('id as cnt').first();
  const seq = (parseInt(result.cnt) || 0) + 1;
  return prefix + String(seq).padStart(4, '0');
};
