const db = require('../config/database');
const { todayCompact } = require('../utils/date.helper');
const TABLE = 'transfer_stock';

exports.findAll = function (cabangId = null) {
  let q = db(TABLE)
    .select(
      'transfer_stock.*',
      'c1.nama as dari_cabang_nama',
      'c2.nama as ke_cabang_nama',
      'b1.nama_barang as barang_asal_nama',
      'b1.barcode_id as barang_asal_barcode',
      'b2.nama_barang as barang_tujuan_nama',
      'b2.barcode_id as barang_tujuan_barcode',
      'p.nama as created_by_nama'
    )
    .leftJoin('cabang as c1', 'transfer_stock.dari_cabang_id', 'c1.id')
    .leftJoin('cabang as c2', 'transfer_stock.ke_cabang_id', 'c2.id')
    .leftJoin('barang as b1', 'transfer_stock.barang_id_asal', 'b1.id')
    .leftJoin('barang as b2', 'transfer_stock.barang_id_tujuan', 'b2.id')
    .leftJoin('pengguna as p', 'transfer_stock.created_by', 'p.id');

  if (cabangId) {
    q = q.where(function () {
      this.where('transfer_stock.dari_cabang_id', cabangId)
        .orWhere('transfer_stock.ke_cabang_id', cabangId);
    });
  }

  return q.orderBy('transfer_stock.created_at', 'desc');
};

exports.getDatatablesData = async function (params, cabangId = null) {
  const { start, length, search, order } = params;

  let baseQuery = db(TABLE)
    .leftJoin('cabang as c1', 'transfer_stock.dari_cabang_id', 'c1.id')
    .leftJoin('cabang as c2', 'transfer_stock.ke_cabang_id', 'c2.id')
    .leftJoin('barang as b1', 'transfer_stock.barang_id_asal', 'b1.id')
    .leftJoin('barang as b2', 'transfer_stock.barang_id_tujuan', 'b2.id')
    .leftJoin('pengguna as p', 'transfer_stock.created_by', 'p.id');

  if (cabangId) {
    baseQuery = baseQuery.where(function () {
      this.where('transfer_stock.dari_cabang_id', cabangId)
        .orWhere('transfer_stock.ke_cabang_id', cabangId);
    });
  }

  const totalCountRes = await baseQuery.clone().count('transfer_stock.id as count').first();
  const recordsTotal = parseInt(totalCountRes.count, 10) || 0;

  if (search && search.value) {
    baseQuery = baseQuery.where(function () {
      this.where('transfer_stock.kode_transfer', 'ilike', `%${search.value}%`)
        .orWhere('c1.nama', 'ilike', `%${search.value}%`)
        .orWhere('c2.nama', 'ilike', `%${search.value}%`)
        .orWhere('b1.nama_barang', 'ilike', `%${search.value}%`)
        .orWhere('b2.nama_barang', 'ilike', `%${search.value}%`);
    });
  }

  const filteredCountRes = await baseQuery.clone().count('transfer_stock.id as count').first();
  const recordsFiltered = parseInt(filteredCountRes.count, 10) || 0;

  if (order && order.length > 0) {
    baseQuery = baseQuery.orderBy('transfer_stock.created_at', order[0].dir === 'desc' ? 'desc' : 'asc');
  } else {
    baseQuery = baseQuery.orderBy('transfer_stock.created_at', 'desc');
  }

  if (length > 0) {
    baseQuery = baseQuery.limit(length).offset(start);
  }

  const data = await baseQuery.select(
    'transfer_stock.*',
    'c1.nama as dari_cabang_nama',
    'c2.nama as ke_cabang_nama',
    'b1.nama_barang as barang_asal_nama',
    'b1.barcode_id as barang_asal_barcode',
    'b2.nama_barang as barang_tujuan_nama',
    'b2.barcode_id as barang_tujuan_barcode',
    'p.nama as created_by_nama'
  );

  return { recordsTotal, recordsFiltered, data };
};

exports.insert = function (trx, data) {
  return trx(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.generateKodeTransfer = async function () {
  const today = todayCompact();
  const prefix = `TRF-${today}-`;
  const lastRec = await db(TABLE)
    .where('kode_transfer', 'like', `${prefix}%`)
    .orderBy('kode_transfer', 'desc')
    .first();

  let seq = 1;
  if (lastRec && lastRec.kode_transfer) {
    const lastSeqStr = lastRec.kode_transfer.replace(prefix, '');
    const lastSeq = parseInt(lastSeqStr, 10);
    if (!isNaN(lastSeq)) seq = lastSeq + 1;
  }
  return prefix + String(seq).padStart(4, '0');
};
