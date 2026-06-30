const db = require('../config/database');
const { todayCompact } = require('../utils/date.helper');
const TABLE = 'penjualan';

exports.findAll = function () {
  return db(TABLE)
    .select('penjualan.*', 'pelanggan.nama as pelanggan_nama', 'sales.nama as sales_nama', 'pengguna.nama as created_by_nama')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .leftJoin('pengguna', 'penjualan.created_by', 'pengguna.id')
    .orderBy('penjualan.created_at', 'desc');
};

exports.getDatatablesData = async function (params) {
  const { start, length, search, order, start_date, end_date, status, is_toko } = params;

  let baseQuery = db(TABLE)
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .leftJoin('pengguna', 'penjualan.created_by', 'pengguna.id')
    .leftJoin('metode_pembayaran', 'penjualan.metode_bayar_id', 'metode_pembayaran.id');

  if (is_toko === 'true' || is_toko === true) {
    baseQuery = baseQuery.where('penjualan.is_b2b', true);
  } else {
    baseQuery = baseQuery.where('penjualan.is_b2b', false);
  }

  if (status) {
    baseQuery = baseQuery.where('penjualan.status_bayar', status);
  }

  const totalCountRes = await baseQuery.clone().count('penjualan.id as count').first();
  const recordsTotal = parseInt(totalCountRes.count);

  if (start_date) baseQuery = baseQuery.where('penjualan.order_date', '>=', start_date);
  if (end_date) baseQuery = baseQuery.where('penjualan.order_date', '<=', end_date);

  if (search && search.value) {
    baseQuery = baseQuery.where(function () {
      this.where('penjualan.no_nota', 'ilike', `%${search.value}%`)
        .orWhere('pelanggan.nama', 'ilike', `%${search.value}%`)
        .orWhere('sales.nama', 'ilike', `%${search.value}%`)
        .orWhereExists(function () {
          this.select('*')
            .from('penjualan_detail')
            .join('barang', 'penjualan_detail.barang_id', 'barang.id')
            .whereRaw('penjualan_detail.penjualan_id = penjualan.id')
            .andWhere('barang.barcode_id', 'ilike', `%${search.value}%`);
        });
    });
  }

  const filteredCountRes = await baseQuery.clone().count('penjualan.id as count').first();
  const recordsFiltered = parseInt(filteredCountRes.count);

  let totalPenjualanKhusus = 0;
  if (is_toko === 'true' || is_toko === true) {
    const sumRes = await baseQuery.clone().select(db.raw("SUM(CASE WHEN status_bayar = 'dp' THEN COALESCE(dp, 0) ELSE total END) as total_khusus")).first();
    totalPenjualanKhusus = sumRes && sumRes.total_khusus ? parseFloat(sumRes.total_khusus) : 0;
  }

  const columns = ['order_date', 'no_nota', 'pelanggan_nama', 'total', 'bpjs', 'dp', null, 'status_bayar', 'sales_nama'];
  const colToDb = {
    order_date: 'penjualan.order_date', no_nota: 'penjualan.no_nota',
    pelanggan_nama: 'pelanggan.nama', total: 'penjualan.total',
    bpjs: 'penjualan.bpjs',
    dp: 'penjualan.dp', status_bayar: 'penjualan.status_bayar',
    sales_nama: 'sales.nama',
  };
  if (order && order.length > 0) {
    const colIndex = parseInt(order[0].column);
    const dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    const colName = columns[colIndex];
    baseQuery = baseQuery.orderBy(colName ? colToDb[colName] : 'penjualan.created_at', dir);
  } else {
    baseQuery = baseQuery.orderBy('penjualan.created_at', 'desc');
  }

  if (length > 0) {
    baseQuery = baseQuery.limit(length).offset(start);
  }

  const data = await baseQuery.select('penjualan.*', 'pelanggan.nama as pelanggan_nama', 'sales.nama as sales_nama', 'pengguna.nama as created_by_nama', 'metode_pembayaran.nama as metode_bayar');

  return { recordsTotal, recordsFiltered, data, totalPenjualanKhusus };
};

exports.findById = function (id) {
  return db(TABLE)
    .select('penjualan.*', 'pelanggan.nama as pelanggan_nama', 'pelanggan.no_telp as pelanggan_telp',
      'sales.nama as sales_nama', 'pengguna.nama as created_by_nama')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .leftJoin('pengguna', 'penjualan.created_by', 'pengguna.id')
    .where('penjualan.id', id).first();
};

exports.insert = function (trx, data) {
  return trx(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.update = function (trx, id, data) {
  return trx(TABLE).where('id', id).update(data);
};

exports.deleteById = function (trx, id) {
  return trx(TABLE).where('id', id).del();
};

exports.findByIdWithTrx = function (trx, id) {
  return trx(TABLE).where('id', id).first();
};

exports.generateNotaNumber = async function (is_b2b) {
  const today = todayCompact();
  const tag = is_b2b ? 'B2B' : 'INV';
  const prefix = `${tag}-${today}-`;
  const lastNota = await db(TABLE)
    .where('no_nota', 'like', `${prefix}%`)
    .orderBy('no_nota', 'desc')
    .first();

  let seq = 1;
  if (lastNota && lastNota.no_nota) {
    const lastSeqStr = lastNota.no_nota.replace(prefix, '');
    const lastSeq = parseInt(lastSeqStr, 10);
    if (!isNaN(lastSeq)) seq = lastSeq + 1;
  }
  return prefix + String(seq).padStart(4, '0');
};

exports.getPelunasanDpDatatablesData = async function (params) {
  const { start, length, search, order, start_date, end_date } = params;

  // Reusable raw expressions for pembayaran subqueries
  const sqlPelunasanDate = db.raw('(SELECT MAX(tanggal_bayar) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id)');
  const sqlTotalBayar = db.raw('((SELECT SUM(jumlah_bayar) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id) - penjualan.dp)');

  let baseQuery = db(TABLE)
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .where('penjualan.status_bayar', 'lunas')
    .whereExists(function () {
      this.select('*').from('kas')
        .whereRaw('kas.penjualan_id = penjualan.id')
        .andWhere('kas.kategori', 'pelunasan');
    });

  if (start_date) baseQuery = baseQuery.whereRaw('(SELECT MAX(DATE(tanggal_bayar)) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id) >= ?', [start_date]);
  if (end_date) baseQuery = baseQuery.whereRaw('(SELECT MAX(DATE(tanggal_bayar)) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id) <= ?', [end_date]);

  const totalCountRes = await baseQuery.clone().count('penjualan.id as count').first();
  const recordsTotal = parseInt(totalCountRes.count);

  if (search && search.value) {
    baseQuery = baseQuery.where(function () {
      this.where('penjualan.no_nota', 'ilike', `%${search.value}%`)
        .orWhere('pelanggan.nama', 'ilike', `%${search.value}%`)
        .orWhere('sales.nama', 'ilike', `%${search.value}%`);
    });
  }

  const filteredCountRes = await baseQuery.clone().count('penjualan.id as count').first();
  const recordsFiltered = parseInt(filteredCountRes.count);

  const grandTotalRes = await db.from(
    baseQuery.clone().select(db.raw('((SELECT SUM(jumlah_bayar) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id) - penjualan.dp) as total_bayar')).as('t')
  ).sum('total_bayar as grandTotal').first();
  const grandTotal = grandTotalRes ? parseFloat(grandTotalRes.grandTotal || 0) : 0;

  // Column mapping for ordering
  const columnMap = {
    no_nota: 'penjualan.no_nota',
    tanggal_pelunasan: sqlPelunasanDate,
    order_date: 'penjualan.order_date',
    pelanggan_nama: 'pelanggan.nama',
    sales_nama: 'sales.nama',
    total: 'penjualan.total',
    dp: 'penjualan.dp',
    total_bayar: sqlTotalBayar,
  };
  const columnKeys = Object.keys(columnMap);

  baseQuery = baseQuery.select(
    'penjualan.id', 'penjualan.no_nota', 'penjualan.order_date',
    'pelanggan.nama as pelanggan_nama', 'sales.nama as sales_nama',
    'penjualan.total', 'penjualan.dp',
    db.raw(`${sqlPelunasanDate} as tanggal_pelunasan`),
    db.raw(`${sqlTotalBayar} as total_bayar`)
  );

  if (order && order.length > 0) {
    const colIndex = parseInt(order[0].column);
    const dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    const orderCol = columnMap[columnKeys[colIndex]];
    baseQuery = baseQuery.orderBy(orderCol || 'penjualan.created_at', dir);
  } else {
    baseQuery = baseQuery.orderBy('penjualan.created_at', 'desc');
  }

  if (length > 0) baseQuery = baseQuery.limit(length).offset(start);

  const data = await baseQuery;
  return { recordsTotal, recordsFiltered, data, grandTotal };
};

/** Check if any penjualan exists for a given pelanggan_id. */
exports.existsByPelangganId = async function (pelangganId) {
  const result = await db.raw(
    'SELECT EXISTS(SELECT 1 FROM penjualan WHERE pelanggan_id = ?) as exists',
    [pelangganId]
  );
  return result.rows[0].exists;
};
