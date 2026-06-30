const db = require('../config/database');
const TABLE = 'komisi_sales';

exports.findByPenjualanIds = function (penjualanIds) {
  return db(TABLE).whereIn('penjualan_id', penjualanIds);
};

exports.insertMany = function (trx, rows) {
  if (!rows.length) return Promise.resolve();
  return trx(TABLE).insert(rows);
};

exports.deleteByPenjualanId = function (trx, penjualanId) {
  return trx(TABLE).where('penjualan_id', penjualanId).del();
};
