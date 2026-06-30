const db = require('../config/database');
const { todayCompact } = require('../utils/date.helper');
const TABLE = 'penjualan_retur';

exports.findAll = function () {
  return db(TABLE)
    .select('penjualan_retur.*', 'penjualan.no_nota', 'pelanggan.nama as pelanggan_nama')
    .leftJoin('penjualan', 'penjualan_retur.penjualan_id', 'penjualan.id')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .orderBy('penjualan_retur.created_at', 'desc');
};

exports.findById = function (id) {
  return db(TABLE)
    .select('penjualan_retur.*', 'penjualan.no_nota', 'pelanggan.nama as pelanggan_nama')
    .leftJoin('penjualan', 'penjualan_retur.penjualan_id', 'penjualan.id')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .where('penjualan_retur.id', id).first();
};

exports.findByPenjualanId = function (trx, penjualanId) {
  return (trx || db)(TABLE).where('penjualan_id', penjualanId);
};

exports.pluckIdsByPenjualanId = function (trx, penjualanId) {
  return (trx || db)(TABLE).where('penjualan_id', penjualanId).pluck('id');
};

exports.insert = function (trx, data) {
  return trx(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.deleteById = function (trx, id) {
  return trx(TABLE).where('id', id).del();
};

exports.deleteByIds = function (trx, ids) {
  if (!ids.length) return Promise.resolve();
  return trx(TABLE).whereIn('id', ids).del();
};

exports.generateKodeRetur = async function () {
  const today = todayCompact();
  const prefix = `RJ-${today}-`;
  const result = await db(TABLE).where('kode_retur', 'like', `${prefix}%`).count('id as cnt').first();
  const seq = (parseInt(result.cnt) || 0) + 1;
  return prefix + String(seq).padStart(4, '0');
};
