const db = require('../config/database');

exports.findAll = function () {
  return db('pembelian')
    .select('pembelian.*', 'supplier.nama as supplier_nama')
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id')
    .orderBy('pembelian.created_at', 'desc');
};

exports.findById = function (id) {
  return db('pembelian')
    .select('pembelian.*', 'supplier.nama as supplier_nama')
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id')
    .where('pembelian.id', id).first();
};

exports.findDetailsByPembelianId = function (pembelianId) {
  return db('pembelian_detail')
    .select('pembelian_detail.*', 'barang.nama_barang', 'barang.barcode_id')
    .leftJoin('barang', 'pembelian_detail.barang_id', 'barang.id')
    .where('pembelian_detail.pembelian_id', pembelianId)
    .orderBy('pembelian_detail.id', 'asc');
};

exports.create = async function (pembelianData, detailItems) {
  return db.transaction(async (trx) => {
    const [pembelian] = await trx('pembelian').insert(pembelianData).returning('*');
    for (const item of detailItems) {
      await trx('pembelian_detail').insert({
        pembelian_id: pembelian.id,
        barang_id: item.barang_id,
        jumlah: item.jumlah || 1,
        harga_beli: item.harga_beli || 0,
      });
      // Increment stock
      if (item.barang_id) {
        await trx('barang').where('id', item.barang_id).increment('qty', item.jumlah || 1);
      }
    }
    return pembelian;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    // Restore stock (decrement back)
    const details = await trx('pembelian_detail').where('pembelian_id', id);
    for (const item of details) {
      if (item.barang_id) {
        await trx('barang').where('id', item.barang_id).decrement('qty', item.jumlah);
      }
    }
    await trx('pembelian').where('id', id).del();
  });
};

exports.generateKodePembelian = async function () {
  const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const prefix = `PI-${today}-`;
  const result = await db('pembelian').where('kode_pembelian', 'like', `${prefix}%`).count('id as cnt').first();
  const seq = (parseInt(result.cnt) || 0) + 1;
  return prefix + String(seq).padStart(4, '0');
};
