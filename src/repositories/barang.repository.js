const db = require('../config/database');
const TABLE = 'barang';

const getNumVal = (col1, col2) => `CAST(NULLIF(REGEXP_REPLACE(COALESCE(${col1}, ${col2}), '[^0-9.-]', '', 'g'), '') AS NUMERIC)`;
const orderSph = `CASE WHEN ${getNumVal('barang.sph_r', 'barang.sph_l')} > 0 THEN 1 WHEN ${getNumVal('barang.sph_r', 'barang.sph_l')} = 0 THEN 2 WHEN ${getNumVal('barang.sph_r', 'barang.sph_l')} < 0 THEN 3 ELSE 4 END ASC, ABS(${getNumVal('barang.sph_r', 'barang.sph_l')}) ASC`;
const orderCyl = `CASE WHEN ${getNumVal('barang.cyl_r', 'barang.cyl_l')} > 0 THEN 1 WHEN ${getNumVal('barang.cyl_r', 'barang.cyl_l')} < 0 THEN 2 WHEN ${getNumVal('barang.cyl_r', 'barang.cyl_l')} = 0 THEN 3 ELSE 4 END ASC, ABS(${getNumVal('barang.cyl_r', 'barang.cyl_l')}) ASC`;
const orderAdd = `CASE WHEN ${getNumVal('barang.add_r', 'barang.add_l')} > 0 THEN 1 WHEN ${getNumVal('barang.add_r', 'barang.add_l')} < 0 THEN 2 WHEN ${getNumVal('barang.add_r', 'barang.add_l')} = 0 THEN 3 ELSE 4 END ASC, ABS(${getNumVal('barang.add_r', 'barang.add_l')}) ASC`;

function applyOpticalSort(query) {
  return query
    .orderByRaw(orderSph)
    .orderByRaw(orderCyl)
    .orderByRaw(orderAdd);
}

exports.findAll = function (filters = {}) {
  let query = db(TABLE)
    .select('barang.*', 'kategori.nama as kategori_nama')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .whereNull('barang.deleted_at');
    
  if (filters.kategori_id) {
    query = query.where('barang.kategori_id', filters.kategori_id);
  }
  
  return applyOpticalSort(query.orderBy('barang.nama_barang', 'asc'));
};

exports.getDatatablesData = async function (params) {
  const { start, length, search, order, kategori_id, columns: dtColumns } = params;
  
  let baseQuery = db(TABLE)
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .whereNull('barang.deleted_at');

  if (kategori_id) {
    baseQuery = baseQuery.where('barang.kategori_id', kategori_id);
  }

  // Count total without search
  const totalCountRes = await baseQuery.clone().count('barang.id as count').first();
  const recordsTotal = parseInt(totalCountRes.count);

  // Apply search
  if (search && search.value) {
    baseQuery = baseQuery.where(function() {
      this.where('barang.nama_barang', 'ilike', `%${search.value}%`)
          .orWhere('barang.barcode_id', 'ilike', `%${search.value}%`);
    });
  }

  // Count filtered
  const filteredCountRes = await baseQuery.clone()
    .select(
      db.raw('COUNT(barang.id) as count'),
      db.raw('SUM(barang.qty) as total_qty'),
      db.raw('SUM(CASE WHEN COALESCE(barang.qty, 0) < 1 THEN 1 ELSE 0 END) as out_of_stock')
    )
    .first();
  const recordsFiltered = parseInt(filteredCountRes.count) || 0;
  const totalQty = parseInt(filteredCountRes.total_qty) || 0;
  const outOfStock = parseInt(filteredCountRes.out_of_stock) || 0;

  // Apply ordering
  if (order && order.length > 0) {
    const colIndex = parseInt(order[0].column);
    const dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    
    const hardcodedColumns = ['nama_barang', 'kategori_nama', 'qty', 'harga_jual', 'barcode_id'];
    let colName = '';
    
    if (dtColumns && dtColumns[colIndex] && dtColumns[colIndex].data) {
      colName = dtColumns[colIndex].data;
    } else {
      colName = hardcodedColumns[colIndex];
    }

    if (colName) {
      const orderCol = colName === 'kategori_nama' ? 'kategori.nama' : `barang.${colName}`;
      baseQuery = baseQuery.orderBy(orderCol, dir);
      if (colName === 'nama_barang') {
        baseQuery = applyOpticalSort(baseQuery);
      }
    } else {
      baseQuery = applyOpticalSort(baseQuery.orderBy('barang.nama_barang', 'asc'));
    }
  } else {
    baseQuery = applyOpticalSort(baseQuery.orderBy('barang.nama_barang', 'asc'));
  }

  // Pagination
  if (length > 0) {
    baseQuery = baseQuery.limit(length).offset(start);
  }

  const data = await baseQuery.select('barang.*', 'kategori.nama as kategori_nama');

  return {
    recordsTotal,
    recordsFiltered,
    totalQty,
    outOfStock,
    data
  };
};

exports.findById = function (id) {
  return db(TABLE)
    .select('barang.*', 'kategori.nama as kategori_nama')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .where('barang.id', id)
    .whereNull('barang.deleted_at')
    .first();
};

exports.search = function (q, kategori_nama) {
  let query = db(TABLE)
    .select('barang.*', 'kategori.nama as kategori_nama')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .whereNull('barang.deleted_at');

  if (kategori_nama) {
    const kats = kategori_nama.split(',').map(k => k.trim());
    query = query.where(function() {
      kats.forEach((kat, i) => {
        if (i === 0) this.where('kategori.nama', 'ilike', `%${kat}%`);
        else this.orWhere('kategori.nama', 'ilike', `%${kat}%`);
      });
    });
  }

  return applyOpticalSort(query.andWhere(function() {
      this.where('barang.nama_barang', 'ilike', `%${q}%`)
          .orWhere('barang.barcode_id', 'ilike', `%${q}%`);
    })
    .orderBy('barang.nama_barang', 'asc'));
};

exports.create = function (data) {
  return db(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.update = function (id, data) {
  data.updated_at = db.fn.now();
  return db(TABLE).where('id', id).update(data).returning('*').then(r => r[0]);
};

exports.del = function (id) {
  return db(TABLE).where('id', id).update({ deleted_at: db.fn.now() });
};

exports.decrementQty = function (id, amount, trx) {
  return (trx || db)(TABLE).where('id', id).decrement('qty', amount);
};

exports.incrementQty = function (id, amount, trx) {
  return (trx || db)(TABLE).where('id', id).increment('qty', amount);
};

exports.updateQty = function (trx, id, qty) {
  return trx(TABLE).where('id', id).update({ qty, updated_at: trx.fn.now() });
};

exports.findByIdWithTrx = function (trx, id) {
  return trx(TABLE).select('qty', 'harga_jual').where('id', id).first();
};

exports.updateFields = function (trx, id, data) {
  return trx(TABLE).where('id', id).update(data);
};

exports.generateBarcodeId = async function () {
  const result = await db(TABLE).max('id as max_id').first();
  const nextId = (result.max_id || 0) + 1;
  return 'BRG-' + String(nextId).padStart(6, '0');
};
