const db = require('../config/database');

exports.findAll = function () {
  return db('penjualan')
    .select('penjualan.*', 'pelanggan.nama as pelanggan_nama', 'sales.nama as sales_nama', 'pengguna.nama as created_by_nama')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .leftJoin('pengguna', 'penjualan.created_by', 'pengguna.id')
    .orderBy('penjualan.created_at', 'desc');
};

exports.findById = function (id) {
  return db('penjualan')
    .select('penjualan.*', 'pelanggan.nama as pelanggan_nama', 'pelanggan.no_telp as pelanggan_telp',
      'sales.nama as sales_nama', 'pengguna.nama as created_by_nama')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .leftJoin('pengguna', 'penjualan.created_by', 'pengguna.id')
    .where('penjualan.id', id).first();
};

exports.findDetailsByPenjualanId = function (penjualanId) {
  return db('penjualan_detail')
    .select('penjualan_detail.*', 'barang.nama_barang', 'barang.barcode_id')
    .leftJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
    .where('penjualan_detail.penjualan_id', penjualanId)
    .orderBy('penjualan_detail.tipe', 'asc');
};

exports.create = async function (penjualanData, detailItems) {
  return db.transaction(async (trx) => {
    const [penjualan] = await trx('penjualan').insert(penjualanData).returning('*');
    for (const item of detailItems) {
      await trx('penjualan_detail').insert({
        penjualan_id: penjualan.id, tipe: item.tipe, barang_id: item.barang_id,
        harga: item.harga || 0, diskon: item.diskon || 0, jumlah: item.jumlah || 1,
      });
      if (item.barang_id) {
        await trx('barang').where('id', item.barang_id).decrement('qty', item.jumlah || 1);
      }
    }
    return penjualan;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    const details = await trx('penjualan_detail').where('penjualan_id', id);
    for (const item of details) {
      if (item.barang_id) {
        await trx('barang').where('id', item.barang_id).increment('qty', item.jumlah);
      }
    }
    await trx('penjualan').where('id', id).del();
  });
};

exports.generateNotaNumber = async function () {
  const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const prefix = `INV-${today}-`;
  const result = await db('penjualan').where('no_nota', 'like', `${prefix}%`).count('id as cnt').first();
  const seq = (parseInt(result.cnt) || 0) + 1;
  return prefix + String(seq).padStart(4, '0');
};
