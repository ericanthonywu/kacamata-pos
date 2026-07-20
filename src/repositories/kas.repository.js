const db = require('../config/database');
const TABLE = 'kas';

exports.insert = function (trx, data) {
  return trx(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.deleteByRef = function (trx, refId, refTipe) {
  return trx(TABLE).where('referensi_id', refId).where('referensi_tipe', refTipe).del();
};

exports.deleteByPenjualanId = function (trx, penjualanId) {
  return trx(TABLE).where('penjualan_id', penjualanId).del();
};

exports.updateMetodeBayarWhereNull = function (trx, penjualanId, metodeBayarId) {
  return trx(TABLE).where('penjualan_id', penjualanId).whereNull('metode_bayar_id').update({ metode_bayar_id: metodeBayarId });
};

// ── Reporting queries (moved from laporan.repository.js) ──

exports.getSummary = async function ({ from, to, sales_id } = {}) {
  let query = db(TABLE)
    .innerJoin('penjualan', 'kas.penjualan_id', 'penjualan.id')
    .leftJoin('metode_pembayaran', 'kas.metode_bayar_id', 'metode_pembayaran.id')
    .where('penjualan.is_b2b', false);

  if (from) query = query.where('kas.tanggal', '>=', from);
  if (to) query = query.where('kas.tanggal', '<=', to);
  if (sales_id) query = query.where('penjualan.sales_id', sales_id);

  const result = await query
    .select(
      db.raw("COUNT(CASE WHEN kas.tipe = 'masuk' THEN 1 END) as total_pembayaran"),
      db.raw("COALESCE(SUM(CASE WHEN kas.tipe = 'masuk' THEN kas.jumlah WHEN kas.tipe = 'keluar' THEN -kas.jumlah ELSE 0 END), 0) as total_uang_masuk"),
      db.raw("COALESCE(SUM(CASE WHEN metode_pembayaran.tipe = 'cash' THEN (CASE WHEN kas.tipe = 'masuk' THEN kas.jumlah WHEN kas.tipe = 'keluar' THEN -kas.jumlah ELSE 0 END) ELSE 0 END), 0) as total_cash"),
      db.raw("COALESCE(SUM(CASE WHEN metode_pembayaran.tipe = 'transfer' THEN (CASE WHEN kas.tipe = 'masuk' THEN kas.jumlah WHEN kas.tipe = 'keluar' THEN -kas.jumlah ELSE 0 END) ELSE 0 END), 0) as total_transfer"),
      db.raw("COALESCE(SUM(CASE WHEN kas.kategori IN ('pembayaran_lunas', 'down_payment') THEN kas.jumlah ELSE 0 END), 0) as uang_dari_penjualan"),
      db.raw("COALESCE(SUM(CASE WHEN kas.kategori = 'pelunasan' THEN kas.jumlah ELSE 0 END), 0) as uang_dari_pelunasan"),
      db.raw("COALESCE(SUM(CASE WHEN kas.tipe = 'keluar' THEN kas.jumlah ELSE 0 END), 0) as total_retur"),
      db.raw("COUNT(CASE WHEN kas.tipe = 'keluar' THEN 1 END) as total_retur_count")
    )
    .first();

  // BPJS is summed per-penjualan filtered by order_date (not by kas payment date)
  // This avoids double-counting for DP + pelunasan transactions
  let bpjsQuery = db('penjualan')
    .where('penjualan.is_b2b', false);
  if (from) bpjsQuery = bpjsQuery.where('penjualan.order_date', '>=', from);
  if (to) bpjsQuery = bpjsQuery.where('penjualan.order_date', '<=', to);
  if (sales_id) bpjsQuery = bpjsQuery.where('penjualan.sales_id', sales_id);

  const bpjsRes = await bpjsQuery.sum('bpjs as total_bpjs').first();
  result.total_bpjs = bpjsRes ? parseFloat(bpjsRes.total_bpjs || 0) : 0;

  return result;
};

exports.getDatatablesData = async function (params) {
  const { start, length, search, order, from, to, sales_id } = params;

  function applyFilters(query) {
    if (from) query = query.where('kas.tanggal', '>=', from);
    if (to) query = query.where('kas.tanggal', '<=', to);
    if (sales_id) query = query.where('penjualan.sales_id', sales_id);
    return query;
  }

  let baseQuery = db(TABLE)
    .innerJoin('penjualan', 'kas.penjualan_id', 'penjualan.id')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .leftJoin('metode_pembayaran', 'kas.metode_bayar_id', 'metode_pembayaran.id')
    .where('penjualan.is_b2b', false);

  baseQuery = applyFilters(baseQuery);

  const totalCountRes = await baseQuery.clone().count('kas.id as count').first();
  const recordsTotal = parseInt(totalCountRes.count);

  if (search && search.value) {
    baseQuery = baseQuery.where(function () {
      this.where('kas.no_referensi', 'ilike', `%${search.value}%`)
        .orWhere('pelanggan.nama', 'ilike', `%${search.value}%`)
        .orWhere('sales.nama', 'ilike', `%${search.value}%`)
        .orWhere('kas.keterangan', 'ilike', `%${search.value}%`);
    });
  }

  const filteredCountRes = await baseQuery.clone().count('kas.id as count').first();
  const recordsFiltered = parseInt(filteredCountRes.count);

  const columnMap = {
    0: 'kas.no_referensi',
    1: 'kas.tanggal',
    2: 'pelanggan.nama',
    3: 'sales.nama',
    4: 'penjualan.subtotal',
    5: 'penjualan.dp',
    8: 'penjualan.bpjs',
    9: 'kas.kategori',
    10: 'kas.jumlah',
  };

  if (order && order.length > 0) {
    const colIndex = parseInt(order[0].column);
    const dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    if (columnMap[colIndex]) {
      baseQuery = baseQuery.orderBy(columnMap[colIndex], dir);
    } else {
      baseQuery = baseQuery.orderBy('kas.tanggal', 'desc');
    }
  } else {
    baseQuery = baseQuery.orderBy('kas.tanggal', 'desc');
  }
  // Secondary sort for consistent ordering
  baseQuery = baseQuery.orderBy('kas.id', 'desc');

  if (parseInt(length) > 0) {
    baseQuery = baseQuery.limit(parseInt(length)).offset(parseInt(start) || 0);
  }

  const data = await baseQuery.select(
    'kas.id',
    'kas.tipe',
    'kas.kategori',
    'kas.jumlah',
    'kas.tanggal as tanggal_bayar',
    'kas.referensi_id',
    'kas.referensi_tipe',
    'kas.penjualan_id',
    'kas.no_referensi as no_nota',
    'kas.keterangan',
    'penjualan.subtotal',
    'penjualan.dp',
    'penjualan.bpjs',
    'penjualan.total',
    'penjualan.status_bayar',
    'metode_pembayaran.nama as metode_bayar',
    'pelanggan.nama as pelanggan_nama',
    'sales.nama as sales_nama'
  );

  return { recordsTotal, recordsFiltered, data };
};

exports.getChartData = async function ({ from, to, sales_id, group_by } = {}) {
  group_by = group_by || 'day';

  let dateExpr;
  switch (group_by) {
    case 'week':
      dateExpr = db.raw("to_char(date_trunc('week', kas.tanggal), 'YYYY-MM-DD')");
      break;
    case 'month':
      dateExpr = db.raw("to_char(kas.tanggal, 'YYYY-MM')");
      break;
    case 'year':
      dateExpr = db.raw("to_char(kas.tanggal, 'YYYY')");
      break;
    default: // day
      dateExpr = db.raw("to_char(kas.tanggal, 'YYYY-MM-DD')");
      break;
  }

  let query = db(TABLE)
    .innerJoin('penjualan', 'kas.penjualan_id', 'penjualan.id')
    .leftJoin('metode_pembayaran', 'kas.metode_bayar_id', 'metode_pembayaran.id')
    .where('penjualan.is_b2b', false);

  if (from) query = query.where('kas.tanggal', '>=', from);
  if (to) query = query.where('kas.tanggal', '<=', to);
  if (sales_id) query = query.where('penjualan.sales_id', sales_id);

  const data = await query
    .select(
      dateExpr.wrap('(', ') as period'),
      db.raw("COALESCE(SUM(CASE WHEN kas.tipe = 'masuk' THEN kas.jumlah ELSE 0 END), 0) as total_masuk"),
      db.raw("COALESCE(SUM(CASE WHEN kas.tipe = 'keluar' THEN kas.jumlah ELSE 0 END), 0) as total_keluar"),
      db.raw("COALESCE(SUM(CASE WHEN kas.tipe = 'masuk' AND metode_pembayaran.tipe = 'cash' THEN kas.jumlah ELSE 0 END), 0) as total_cash"),
      db.raw("COALESCE(SUM(CASE WHEN kas.tipe = 'masuk' AND metode_pembayaran.tipe = 'transfer' THEN kas.jumlah ELSE 0 END), 0) as total_transfer")
    )
    .groupByRaw('1')
    .orderByRaw('1 ASC');

  return data.map(row => ({
    period: row.period,
    total_masuk: parseFloat(row.total_masuk) || 0,
    total_keluar: parseFloat(row.total_keluar) || 0,
    total_cash: parseFloat(row.total_cash) || 0,
    total_transfer: parseFloat(row.total_transfer) || 0,
    net: (parseFloat(row.total_masuk) || 0) - (parseFloat(row.total_keluar) || 0),
  }));
};

exports.getDashboardSummary = async function (today, firstOfMonth) {
  // 1. Penjualan stats (non-B2B): today + month counts
  const penjualanStats = await db('penjualan')
    .where('is_b2b', false)
    .select(
      db.raw('COUNT(CASE WHEN order_date = ? THEN 1 END) as transaksi_today', [today]),
      db.raw('COUNT(CASE WHEN order_date >= ? THEN 1 END) as transaksi_month', [firstOfMonth]),
      db.raw("COUNT(CASE WHEN status_bayar = 'dp' THEN 1 END) as dp_count")
    )
    .first();

  // 2. Kas stats (cash in / cash out): today + month
  const kasStats = await db(TABLE)
    .select(
      db.raw("COALESCE(SUM(CASE WHEN tipe = 'masuk' AND tanggal = ? THEN jumlah ELSE 0 END), 0) as cash_in_today", [today]),
      db.raw("COALESCE(SUM(CASE WHEN tipe = 'keluar' AND tanggal = ? THEN jumlah ELSE 0 END), 0) as cash_out_today", [today]),
      db.raw("COALESCE(SUM(CASE WHEN tipe = 'masuk' AND tanggal >= ? THEN jumlah ELSE 0 END), 0) as cash_in_month", [firstOfMonth]),
      db.raw("COALESCE(SUM(CASE WHEN tipe = 'keluar' AND tanggal >= ? THEN jumlah ELSE 0 END), 0) as cash_out_month", [firstOfMonth])
    )
    .first();

  // 3. Barang stats
  const barangStats = await db('barang')
    .whereNull('deleted_at')
    .select(
      db.raw('COUNT(*) as total_aktif'),
      db.raw('COUNT(CASE WHEN qty < 0 THEN 1 END) as stok_minus')
    )
    .first();

  // 4. Hutang supplier (pembelian belum lunas)
  const hutangRes = await db('pembelian')
    .where('status_bayar', 'belum_lunas')
    .select(
      db.raw('COALESCE(SUM(total_harga - COALESCE((SELECT SUM(jumlah_bayar) FROM pembayaran_pembelian WHERE pembelian_id = pembelian.id), 0)), 0) as total_hutang')
    )
    .first();

  return {
    today: {
      transaksi: parseInt(penjualanStats.transaksi_today) || 0,
      cash_in: parseFloat(kasStats.cash_in_today) || 0,
      cash_out: parseFloat(kasStats.cash_out_today) || 0,
    },
    month: {
      transaksi: parseInt(penjualanStats.transaksi_month) || 0,
      cash_in: parseFloat(kasStats.cash_in_month) || 0,
      cash_out: parseFloat(kasStats.cash_out_month) || 0,
      hutang_supplier: parseFloat(hutangRes.total_hutang) || 0,
    },
    barang: {
      total_aktif: parseInt(barangStats.total_aktif) || 0,
      stok_minus: parseInt(barangStats.stok_minus) || 0,
    },
    dp_count: parseInt(penjualanStats.dp_count) || 0,
  };
};

