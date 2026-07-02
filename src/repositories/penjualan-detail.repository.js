const db = require('../config/database');
const TABLE = 'penjualan_detail';

exports.findByPenjualanId = function (penjualanId) {
  return db(TABLE)
    .select(
      'penjualan_detail.*',
      'barang.nama_barang',
      'barang.barcode_id',
      'barang.sph_r as b_sph_r', 'barang.cyl_r as b_cyl_r', 'barang.add_r as b_add_r',
      'barang.sph_l as b_sph_l', 'barang.cyl_l as b_cyl_l', 'barang.add_l as b_add_l',
      'kategori.nama as kategori_nama'
    )
    .leftJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .where('penjualan_detail.penjualan_id', penjualanId)
    .orderBy('penjualan_detail.tipe', 'asc');
};

exports.findRawByPenjualanId = function (penjualanId, trx) {
  return (trx || db)(TABLE).where('penjualan_id', penjualanId);
};

exports.insertMany = function (trx, rows) {
  if (!rows.length) return Promise.resolve();
  return trx(TABLE).insert(rows);
};

exports.deleteByPenjualanId = function (trx, penjualanId) {
  return trx(TABLE).where('penjualan_id', penjualanId).del();
};

/** Read-only: top selling items by qty within a date range. */
exports.getTopBarang = function (from, to, limit) {
  return db(TABLE)
    .select(
      'barang.nama_barang',
      'barang.harga_jual',
      'kategori.nama as kategori_nama',
      db.raw('SUM(penjualan_detail.jumlah) as total_qty')
    )
    .innerJoin('penjualan', 'penjualan_detail.penjualan_id', 'penjualan.id')
    .innerJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .where('penjualan.is_b2b', false)
    .where('penjualan.order_date', '>=', from)
    .where('penjualan.order_date', '<=', to)
    .groupBy('barang.id', 'barang.nama_barang', 'barang.harga_jual', 'kategori.nama')
    .orderBy('total_qty', 'desc')
    .limit(limit || 10);
};

