const db = require('../config/database');
const { todayCompact } = require('../utils/date.helper');
const TABLE = 'pembelian_retur';

exports.findAll = function () {
  return db(TABLE)
    .select('pembelian_retur.*', 'pembelian.kode_pembelian', 'supplier.nama as supplier_nama')
    .leftJoin('pembelian', 'pembelian_retur.pembelian_id', 'pembelian.id')
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id')
    .orderBy('pembelian_retur.created_at', 'desc');
};

exports.findById = function (id) {
  return db(TABLE)
    .select('pembelian_retur.*', 'pembelian.kode_pembelian', 'supplier.nama as supplier_nama')
    .leftJoin('pembelian', 'pembelian_retur.pembelian_id', 'pembelian.id')
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id')
    .where('pembelian_retur.id', id).first();
};

exports.insert = function (trx, data) {
  return trx(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.deleteById = function (trx, id) {
  return trx(TABLE).where('id', id).del();
};

exports.generateKodeRetur = async function () {
  const today = todayCompact();
  const prefix = `RPI-${today}-`;
  const result = await db(TABLE).where('kode_retur', 'like', `${prefix}%`).count('id as cnt').first();
  const seq = (parseInt(result.cnt) || 0) + 1;
  return prefix + String(seq).padStart(4, '0');
};
