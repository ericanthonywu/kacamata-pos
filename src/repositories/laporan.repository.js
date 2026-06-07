const db = require('../config/database');

exports.getKasReport = function ({ from, to, sales_id } = {}) {
  let query = db('penjualan')
    .select('penjualan.id', 'penjualan.no_nota', 'penjualan.order_date',
      'penjualan.subtotal', 'penjualan.biaya', 'penjualan.bpjs',
      'penjualan.total', 'penjualan.dp', 'penjualan.status_bayar', 'penjualan.created_at',
      'pelanggan.nama as pelanggan_nama', 'sales.nama as sales_nama')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id');
  if (from) query = query.where('penjualan.order_date', '>=', from);
  if (to) query = query.where('penjualan.order_date', '<=', to);
  if (sales_id) query = query.where('penjualan.sales_id', sales_id);
  return query.orderBy('penjualan.order_date', 'desc');
};

exports.getSummary = function ({ from, to, sales_id } = {}) {
  let query = db('penjualan')
    .count('id as total_transaksi')
    .sum('subtotal as total_subtotal')
    .select(db.raw("SUM(CASE WHEN status_bayar != 'lunas' AND (subtotal - dp - bpjs) > 0 THEN dp ELSE 0 END) as total_dp_belum_lunas"))
    .sum('bpjs as total_bpjs')
    .sum('total as total_penjualan');
  if (from) query = query.where('order_date', '>=', from);
  if (to) query = query.where('order_date', '<=', to);
  if (sales_id) query = query.where('sales_id', sales_id);
  return query.first();
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
