const db = require('../config/database');
const TABLE = 'bukti_hitung_fisik';

exports.create = function (data) {
  return db(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.getDatatablesData = async function (params) {
  const { start, length, search, order, from, to, columns: dtColumns } = params;

  let baseQuery = db(TABLE);

  // Date range filter
  if (from) {
    baseQuery = baseQuery.where('created_at', '>=', `${from} 00:00:00`);
  }
  if (to) {
    baseQuery = baseQuery.where('created_at', '<=', `${to} 23:59:59`);
  }

  // Count total (with date filters applied)
  const totalCountRes = await baseQuery.clone().count('id as count').first();
  const recordsTotal = parseInt(totalCountRes.count);

  // Apply search
  if (search && search.value) {
    baseQuery = baseQuery.where(function () {
      this.where('nama_barang', 'ilike', `%${search.value}%`)
        .orWhere('barcode_id', 'ilike', `%${search.value}%`)
        .orWhere('diubah_oleh', 'ilike', `%${search.value}%`);
    });
  }

  // Count filtered
  const filteredCountRes = await baseQuery.clone().count('id as count').first();
  const recordsFiltered = parseInt(filteredCountRes.count);

  // Apply ordering
  const columnMap = ['nama_barang', 'barcode_id', 'qty_sebelum', 'qty_sesudah', 'selisih', 'diubah_oleh', 'created_at'];
  if (order && order.length > 0) {
    const colIndex = parseInt(order[0].column);
    const dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    let colName = '';

    if (dtColumns && dtColumns[colIndex] && dtColumns[colIndex].data) {
      colName = dtColumns[colIndex].data;
    } else if (colIndex >= 0 && colIndex < columnMap.length) {
      colName = columnMap[colIndex];
    }

    if (colName) {
      baseQuery = baseQuery.orderBy(colName, dir);
    } else {
      baseQuery = baseQuery.orderBy('created_at', 'desc');
    }
  } else {
    baseQuery = baseQuery.orderBy('created_at', 'desc');
  }

  // Pagination
  if (length > 0) {
    baseQuery = baseQuery.limit(length).offset(start);
  }

  const data = await baseQuery.select('*');

  return { recordsTotal, recordsFiltered, data };
};

exports.findById = function (id) {
  return db(TABLE).where('id', id).first();
};

exports.del = function (id) {
  return db(TABLE).where('id', id).del();
};
