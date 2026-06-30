const db = require('../config/database');
const TABLE = 'pembelian_detail';

exports.findByPembelianId = function (pembelianId) {
  return db(TABLE)
    .select(
      'pembelian_detail.*',
      'barang.nama_barang',
      'barang.barcode_id',
      'barang.harga_jual',
      'barang.sph_r',
      'barang.sph_l',
      'barang.cyl_r',
      'barang.cyl_l',
      'barang.add_r',
      'barang.add_l',
      'kategori.nama as kategori_nama'
    )
    .leftJoin('barang', 'pembelian_detail.barang_id', 'barang.id')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .where('pembelian_detail.pembelian_id', pembelianId)
    .orderBy('pembelian_detail.id', 'asc');
};

exports.findRawByPembelianId = function (trx, pembelianId) {
  return (trx || db)(TABLE).where('pembelian_id', pembelianId);
};

exports.insertMany = function (trx, rows) {
  if (!rows.length) return Promise.resolve();
  return trx(TABLE).insert(rows);
};

exports.deleteByPembelianId = function (trx, pembelianId) {
  return trx(TABLE).where('pembelian_id', pembelianId).del();
};
