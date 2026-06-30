const db = require('../config/database');

/**
 * Reporting-only repository for cross-table komisi queries.
 * Kas-related reporting methods have been moved to kas.repository.js.
 */

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
