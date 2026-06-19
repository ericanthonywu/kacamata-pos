const db = require('../config/database');

exports.getSummary = async function ({ from, to, sales_id } = {}) {
  let query = db('pembayaran_penjualan')
    .innerJoin('penjualan', 'pembayaran_penjualan.penjualan_id', 'penjualan.id');

  if (from) query = query.where('pembayaran_penjualan.tanggal_bayar', '>=', from);
  if (to) query = query.where('pembayaran_penjualan.tanggal_bayar', '<=', to);
  if (sales_id) query = query.where('penjualan.sales_id', sales_id);

  const result = await query
    .select(
      db.raw('COUNT(pembayaran_penjualan.id) as total_pembayaran'),
      db.raw('COALESCE(SUM(pembayaran_penjualan.jumlah_bayar), 0) as total_uang_masuk'),
      db.raw("COALESCE(SUM(CASE WHEN pembayaran_penjualan.keterangan IN ('Pembayaran lunas', 'Down Payment') THEN pembayaran_penjualan.jumlah_bayar ELSE 0 END), 0) as uang_dari_penjualan"),
      db.raw("COALESCE(SUM(CASE WHEN pembayaran_penjualan.keterangan NOT IN ('Pembayaran lunas', 'Down Payment') THEN pembayaran_penjualan.jumlah_bayar ELSE 0 END), 0) as uang_dari_pelunasan")
    )
    .first();

  // Get total BPJS from penjualan within the date range (based on distinct penjualan in pembayaran)
  let bpjsQuery = db('penjualan')
    .whereExists(function () {
      this.select('*').from('pembayaran_penjualan')
        .whereRaw('pembayaran_penjualan.penjualan_id = penjualan.id');
      if (from) this.andWhere('pembayaran_penjualan.tanggal_bayar', '>=', from);
      if (to) this.andWhere('pembayaran_penjualan.tanggal_bayar', '<=', to);
    });
  if (sales_id) bpjsQuery = bpjsQuery.where('penjualan.sales_id', sales_id);

  const bpjsRes = await bpjsQuery.sum('bpjs as total_bpjs').first();
  result.total_bpjs = bpjsRes ? parseFloat(bpjsRes.total_bpjs || 0) : 0;

  return result;
};

exports.getKasDatatablesData = async function (params) {
  const { start, length, search, order, from, to, sales_id } = params;

  function applyFilters(query) {
    if (from) query = query.where('pembayaran_penjualan.tanggal_bayar', '>=', from);
    if (to) query = query.where('pembayaran_penjualan.tanggal_bayar', '<=', to);
    if (sales_id) query = query.where('penjualan.sales_id', sales_id);
    return query;
  }

  let baseQuery = db('pembayaran_penjualan')
    .innerJoin('penjualan', 'pembayaran_penjualan.penjualan_id', 'penjualan.id')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id');

  baseQuery = applyFilters(baseQuery);

  const totalCountRes = await baseQuery.clone().count('pembayaran_penjualan.id as count').first();
  const recordsTotal = parseInt(totalCountRes.count);

  if (search && search.value) {
    baseQuery = baseQuery.where(function () {
      this.where('penjualan.no_nota', 'ilike', `%${search.value}%`)
        .orWhere('pelanggan.nama', 'ilike', `%${search.value}%`)
        .orWhere('sales.nama', 'ilike', `%${search.value}%`)
        .orWhere('pembayaran_penjualan.keterangan', 'ilike', `%${search.value}%`);
    });
  }

  const filteredCountRes = await baseQuery.clone().count('pembayaran_penjualan.id as count').first();
  const recordsFiltered = parseInt(filteredCountRes.count);

  // Column index mapping: 0=no_nota, 1=tanggal+waktu, 2=pelanggan, 3=sales, 4=subtotal, 5=dp, 6=bpjs, 7=sisa(no sort), 8=keterangan, 9=uang_masuk(admin), 10=aksi(no sort)
  const columnMap = {
    0: 'penjualan.no_nota',
    1: 'pembayaran_penjualan.created_at',
    2: 'pelanggan.nama',
    3: 'sales.nama',
    4: 'penjualan.subtotal',
    5: 'penjualan.dp',
    6: 'penjualan.bpjs',
    8: 'pembayaran_penjualan.keterangan',
    9: 'pembayaran_penjualan.jumlah_bayar',
  };
  if (order && order.length > 0) {
    const colIndex = parseInt(order[0].column);
    const dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    if (columnMap[colIndex]) {
      baseQuery = baseQuery.orderBy(columnMap[colIndex], dir);
    } else {
      baseQuery = baseQuery.orderBy('pembayaran_penjualan.created_at', 'desc');
    }
  } else {
    baseQuery = baseQuery.orderBy('pembayaran_penjualan.created_at', 'desc');
  }

  if (length > 0) {
    baseQuery = baseQuery.limit(length).offset(start);
  }

  const data = await baseQuery.select(
    'pembayaran_penjualan.id',
    'pembayaran_penjualan.tanggal_bayar',
    'pembayaran_penjualan.created_at as waktu_bayar',
    'pembayaran_penjualan.jumlah_bayar',
    'pembayaran_penjualan.keterangan',
    'pembayaran_penjualan.penjualan_id',
    'penjualan.no_nota',
    'penjualan.subtotal',
    'penjualan.dp',
    'penjualan.bpjs',
    'penjualan.total',
    'penjualan.status_bayar',
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
