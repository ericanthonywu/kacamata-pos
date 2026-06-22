const db = require('../config/database');

exports.getSummary = async function ({ from, to, sales_id } = {}) {
  let query = db('kas')
    .innerJoin('penjualan', 'kas.penjualan_id', 'penjualan.id')
    .where('penjualan.is_b2b', false);

  if (from) query = query.where('kas.tanggal', '>=', from);
  if (to) query = query.where('kas.tanggal', '<=', to);
  if (sales_id) query = query.where('penjualan.sales_id', sales_id);

  const result = await query
    .select(
      db.raw("COUNT(CASE WHEN kas.tipe = 'masuk' THEN 1 END) as total_pembayaran"),
      db.raw("COALESCE(SUM(CASE WHEN kas.tipe = 'masuk' THEN kas.jumlah ELSE 0 END), 0) as total_uang_masuk"),
      db.raw("COALESCE(SUM(CASE WHEN kas.kategori IN ('pembayaran_lunas', 'down_payment') THEN kas.jumlah ELSE 0 END), 0) as uang_dari_penjualan"),
      db.raw("COALESCE(SUM(CASE WHEN kas.kategori = 'pelunasan' THEN kas.jumlah ELSE 0 END), 0) as uang_dari_pelunasan"),
      db.raw("COALESCE(SUM(CASE WHEN kas.tipe = 'keluar' THEN kas.jumlah ELSE 0 END), 0) as total_retur"),
      db.raw("COUNT(CASE WHEN kas.tipe = 'keluar' THEN 1 END) as total_retur_count")
    )
    .first();

  // BPJS is on penjualan table, needs a separate query
  let bpjsQuery = db('penjualan')
    .whereExists(function () {
      this.select('*').from('kas')
        .whereRaw('kas.penjualan_id = penjualan.id')
        .where('kas.tipe', 'masuk');
      if (from) this.andWhere('kas.tanggal', '>=', from);
      if (to) this.andWhere('kas.tanggal', '<=', to);
    });
  if (sales_id) bpjsQuery = bpjsQuery.where('penjualan.sales_id', sales_id);
  bpjsQuery = bpjsQuery.where('penjualan.is_b2b', false);

  const bpjsRes = await bpjsQuery.sum('bpjs as total_bpjs').first();
  result.total_bpjs = bpjsRes ? parseFloat(bpjsRes.total_bpjs || 0) : 0;

  return result;
};

exports.getKasDatatablesData = async function (params) {
  const { start, length, search, order, from, to, sales_id } = params;

  function applyFilters(query) {
    if (from) query = query.where('kas.tanggal', '>=', from);
    if (to) query = query.where('kas.tanggal', '<=', to);
    if (sales_id) query = query.where('penjualan.sales_id', sales_id);
    return query;
  }

  let baseQuery = db('kas')
    .innerJoin('penjualan', 'kas.penjualan_id', 'penjualan.id')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
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

  // Column index: 0=no_nota, 1=tanggal, 2=pelanggan, 3=sales, 4=subtotal,
  // 5=dp, 6=pelunasan(no sort), 7=sisa(no sort), 8=bpjs, 9=status, 10=uang_masuk(admin), 11=aksi(no sort)
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
    'penjualan.metode_bayar',
    'pelanggan.nama as pelanggan_nama',
    'sales.nama as sales_nama'
  );

  return { recordsTotal, recordsFiltered, data };
};

exports.getKomisiReport = async function ({ from, to, sales_id, tipe } = {}) {
  let pQuery = db('penjualan')
    .select('penjualan.*', 'sales.nama as sales_nama', 'sales.komisi_frame', 'sales.komisi_lensa')
    .innerJoin('sales', 'penjualan.sales_id', 'sales.id')
    .where('penjualan.status_bayar', 'lunas');

  if (from) pQuery = pQuery.where('penjualan.order_date', '>=', from);
  if (to) pQuery = pQuery.where('penjualan.order_date', '<=', to);
  if (sales_id) pQuery = pQuery.where('penjualan.sales_id', sales_id);

  const transactions = await pQuery;
  if (!transactions.length) return [];

  const pIds = transactions.map(t => t.id);
  const details = await db('penjualan_detail').whereIn('penjualan_id', pIds);
  const komisi = await db('komisi_sales').whereIn('penjualan_id', pIds);

  const result = {};
  for (const t of transactions) {
    if (!result[t.sales_id]) {
      result[t.sales_id] = {
        sales_id: t.sales_id,
        sales_nama: t.sales_nama,
        komisi_frame: t.komisi_frame || 0,
        komisi_lensa: t.komisi_lensa || 0,
        total_transaksi: 0,
        total_penjualan: 0,
        total_penjualan_frame: 0,
        total_penjualan_lensa: 0,
        total_komisi: 0
      };
    }
    const s = result[t.sales_id];
    s.total_transaksi += 1;
    s.total_penjualan += parseFloat(t.total || 0);

    // Calculate base sales per category from details
    const tDetails = details.filter(d => d.penjualan_id === t.id);
    for (const d of tDetails) {
      const lineTotal = (parseFloat(d.harga || 0) - parseFloat(d.diskon || 0)) * parseInt(d.jumlah || 1);
      if (d.tipe === 'frame') s.total_penjualan_frame += lineTotal;
      else if (d.tipe === 'lensa_r' || d.tipe === 'lensa_l') s.total_penjualan_lensa += lineTotal;
    }

    // Add actual historical commission from komisi_sales
    const tKomisi = komisi.filter(k => k.penjualan_id === t.id);
    for (const k of tKomisi) {
      if (tipe && tipe !== 'semua' && k.tipe !== tipe) continue;
      s.total_komisi += parseFloat(k.nominal_komisi || 0);
    }
  }

  return Object.values(result).sort((a, b) => b.total_komisi - a.total_komisi);
};

exports.getKomisiDetail = async function ({ from, to, sales_id, tipe } = {}) {
  let query = db('komisi_sales')
    .select(
      'komisi_sales.id',
      'komisi_sales.tipe',
      'komisi_sales.persentase',
      'komisi_sales.nominal_komisi',
      'komisi_sales.created_at as tanggal_masuk',
      'penjualan.no_nota',
      'penjualan.subtotal',
      db.raw(`(
        SELECT COALESCE(SUM((pd.harga - pd.diskon) * pd.jumlah), 0)
        FROM penjualan_detail pd
        WHERE pd.penjualan_id = komisi_sales.penjualan_id
        AND (
          (komisi_sales.tipe = 'frame' AND pd.tipe = 'frame')
          OR
          (komisi_sales.tipe = 'lensa' AND pd.tipe IN ('lensa_r', 'lensa_l'))
        )
      ) as subtotal_kategori`),
      'penjualan.total as total_penjualan',
      'penjualan.order_date'
    )
    .innerJoin('penjualan', 'komisi_sales.penjualan_id', 'penjualan.id')
    .where('penjualan.status_bayar', 'lunas');

  if (sales_id) query = query.where('komisi_sales.sales_id', sales_id);
  if (from) query = query.where('penjualan.order_date', '>=', from);
  if (to) query = query.where('penjualan.order_date', '<=', to);
  if (tipe && tipe !== 'semua') query = query.where('komisi_sales.tipe', tipe);

  return await query.orderBy('komisi_sales.created_at', 'desc');
};
