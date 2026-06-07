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

exports.getKomisiReport = function ({ from, to, sales_id, tipe } = {}) {
  let query = db('penjualan')
    .select(
      'sales.id as sales_id',
      'sales.nama as sales_nama',
      db.raw('MAX(komisi_sales.persentase) as persentase_komisi'),
      db.raw('COUNT(DISTINCT penjualan.id) as total_transaksi'),
      db.raw('SUM(penjualan.total) as total_penjualan'),
      db.raw('COALESCE(SUM(komisi_sales.nominal_komisi), 0) as total_komisi')
    )
    .innerJoin('komisi_sales', 'penjualan.id', 'komisi_sales.penjualan_id')
    .innerJoin('sales', 'komisi_sales.sales_id', 'sales.id')
    .where('penjualan.status_bayar', 'lunas');
  
  if (from) query = query.where('penjualan.order_date', '>=', from);
  if (to) query = query.where('penjualan.order_date', '<=', to);
  if (sales_id) query = query.where('penjualan.sales_id', sales_id);
  if (tipe && tipe !== 'semua') query = query.where('komisi_sales.tipe', tipe);
  
  return query
    .groupBy('sales.id', 'sales.nama')
    .orderBy('total_komisi', 'desc');
};
