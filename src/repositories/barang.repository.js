const db = require('../config/database');
const TABLE = 'barang';

exports.findAll = function (filters = {}) {
  let query = db(TABLE)
    .select('barang.*', 'kategori.nama as kategori_nama')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id');
    
  if (filters.kategori_id) {
    query = query.where('barang.kategori_id', filters.kategori_id);
  }
  
  return query.orderBy('barang.nama_barang', 'asc');
};

exports.getDatatablesData = async function (params) {
  const { start, length, search, order, kategori_id } = params;
  
  let baseQuery = db(TABLE)
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id');

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
  const filteredCountRes = await baseQuery.clone().count('barang.id as count').sum('barang.qty as total_qty').first();
  const recordsFiltered = parseInt(filteredCountRes.count);
  const totalQty = parseInt(filteredCountRes.total_qty) || 0;

  // Apply ordering
  const columns = ['nama_barang', 'kategori_nama', 'qty', 'harga_jual', 'barcode_id'];
  if (order && order.length > 0) {
    const colIndex = parseInt(order[0].column);
    const dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    if (columns[colIndex]) {
      const orderCol = columns[colIndex] === 'kategori_nama' ? 'kategori.nama' : `barang.${columns[colIndex]}`;
      baseQuery = baseQuery.orderBy(orderCol, dir);
    } else {
      baseQuery = baseQuery.orderBy('barang.nama_barang', 'asc');
    }
  } else {
    baseQuery = baseQuery.orderBy('barang.nama_barang', 'asc');
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
    data
  };
};

exports.findById = function (id) {
  return db(TABLE)
    .select('barang.*', 'kategori.nama as kategori_nama')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .where('barang.id', id)
    .first();
};

exports.search = function (q, kategori_nama) {
  let query = db(TABLE)
    .select('barang.*', 'kategori.nama as kategori_nama')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id');

  if (kategori_nama) {
    const kats = kategori_nama.split(',').map(k => k.trim());
    query = query.where(function() {
      kats.forEach((kat, i) => {
        if (i === 0) this.where('kategori.nama', 'ilike', `%${kat}%`);
        else this.orWhere('kategori.nama', 'ilike', `%${kat}%`);
      });
    });
  }

  return query.andWhere(function() {
      this.where('barang.nama_barang', 'ilike', `%${q}%`)
          .orWhere('barang.barcode_id', 'ilike', `%${q}%`);
    })
    .orderBy('barang.nama_barang', 'asc')
    .limit(20);
};

exports.create = function (data) {
  return db(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.update = function (id, data) {
  data.updated_at = db.fn.now();
  return db(TABLE).where('id', id).update(data).returning('*').then(r => r[0]);
};

exports.del = function (id) {
  return db(TABLE).where('id', id).del();
};

exports.decrementQty = function (id, amount) {
  return db(TABLE).where('id', id).decrement('qty', amount);
};

exports.incrementQty = function (id, amount) {
  return db(TABLE).where('id', id).increment('qty', amount);
};
