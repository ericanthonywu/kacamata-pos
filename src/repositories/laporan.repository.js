const db = require('../config/database');

exports.getKasReport = function ({ from, to, sales_id, kategori_id, status_bayar } = {}) {
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
  if (status_bayar) query = query.where('penjualan.status_bayar', status_bayar);
  if (kategori_id) {
    const applyKategori = (q) => {
      if (kategori_id === 'both') {
        return q.whereExists(function () {
          this.select('*').from('penjualan_detail')
            .innerJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
            .innerJoin('kategori', 'barang.kategori_id', 'kategori.id')
            .whereRaw('penjualan_detail.penjualan_id = penjualan.id')
            .andWhereRaw('LOWER(kategori.nama) = ?', ['frame']);
        }).whereExists(function () {
          this.select('*').from('penjualan_detail')
            .innerJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
            .innerJoin('kategori', 'barang.kategori_id', 'kategori.id')
            .whereRaw('penjualan_detail.penjualan_id = penjualan.id')
            .andWhereRaw('LOWER(kategori.nama) = ?', ['lensa']);
        });
      } else {
        return q.whereExists(function () {
          this.select('*').from('penjualan_detail')
            .innerJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
            .whereRaw('penjualan_detail.penjualan_id = penjualan.id')
            .andWhere('barang.kategori_id', kategori_id);
        });
      }
    };
    query = applyKategori(query);
    pelunasanQuery = applyKategori(pelunasanQuery);
  }
  return query.orderBy('penjualan.order_date', 'desc');
};

exports.getSummary = async function ({ from, to, sales_id, kategori_id, status_bayar } = {}) {
  // Main summary for sales
  let query = db('penjualan')
    .count('id as total_transaksi')
    .sum('subtotal as total_subtotal')
    .sum('bpjs as total_bpjs')
    .select(db.raw('SUM(total - COALESCE(dp, 0)) as total_penjualan'));

  if (from) query = query.where('order_date', '>=', from);
  if (to) query = query.where('order_date', '<=', to);
  if (sales_id) query = query.where('sales_id', sales_id);
  if (status_bayar) query = query.where('status_bayar', status_bayar);

  // Pelunasan summary filtered by tanggal_bayar instead of order_date
  let pelunasanQuery = db('penjualan')
    .where('penjualan.dp', '>', 0)
    .andWhere('penjualan.status_bayar', 'lunas');

  if (from) pelunasanQuery = pelunasanQuery.whereRaw('(SELECT MAX(DATE(tanggal_bayar)) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id) >= ?', [from]);
  if (to) pelunasanQuery = pelunasanQuery.whereRaw('(SELECT MAX(DATE(tanggal_bayar)) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id) <= ?', [to]);
  if (sales_id) pelunasanQuery = pelunasanQuery.where('penjualan.sales_id', sales_id);

  if (kategori_id) {
    if (kategori_id === 'both') {
      query = query.whereExists(function () {
        this.select('*').from('penjualan_detail')
          .innerJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
          .innerJoin('kategori', 'barang.kategori_id', 'kategori.id')
          .whereRaw('penjualan_detail.penjualan_id = penjualan.id')
          .andWhereRaw('LOWER(kategori.nama) = ?', ['frame']);
      }).whereExists(function () {
        this.select('*').from('penjualan_detail')
          .innerJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
          .innerJoin('kategori', 'barang.kategori_id', 'kategori.id')
          .whereRaw('penjualan_detail.penjualan_id = penjualan.id')
          .andWhereRaw('LOWER(kategori.nama) = ?', ['lensa']);
      });
    } else {
      query = query.whereExists(function () {
        this.select('*').from('penjualan_detail')
          .innerJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
          .whereRaw('penjualan_detail.penjualan_id = penjualan.id')
          .andWhere('barang.kategori_id', kategori_id);
      });
    }
  }

  const mainSummary = await query.first();

  const pelunasanRes = await db.from(
    pelunasanQuery.select(db.raw('((SELECT SUM(jumlah_bayar) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id) - penjualan.dp) as total_bayar')).as('t')
  ).sum('total_bayar as total_pelunasan').first();

  mainSummary.total_pelunasan = pelunasanRes ? parseFloat(pelunasanRes.total_pelunasan || 0) : 0;

  return mainSummary;
};

exports.getKasDatatablesData = async function (params) {
  const { start, length, search, order, from, to, sales_id, kategori_id, status_bayar } = params;

  function applyFilters(query) {
    if (from) query = query.where('penjualan.order_date', '>=', from);
    if (to) query = query.where('penjualan.order_date', '<=', to);
    if (sales_id) query = query.where('penjualan.sales_id', sales_id);
    if (status_bayar) query = query.where('penjualan.status_bayar', status_bayar);
    if (kategori_id) {
      if (kategori_id === 'both') {
        query = query.whereExists(function () {
          this.select('*').from('penjualan_detail')
            .innerJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
            .innerJoin('kategori', 'barang.kategori_id', 'kategori.id')
            .whereRaw('penjualan_detail.penjualan_id = penjualan.id')
            .andWhereRaw('LOWER(kategori.nama) = ?', ['frame']);
        }).whereExists(function () {
          this.select('*').from('penjualan_detail')
            .innerJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
            .innerJoin('kategori', 'barang.kategori_id', 'kategori.id')
            .whereRaw('penjualan_detail.penjualan_id = penjualan.id')
            .andWhereRaw('LOWER(kategori.nama) = ?', ['lensa']);
        });
      } else {
        query = query.whereExists(function () {
          this.select('*').from('penjualan_detail')
            .innerJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
            .whereRaw('penjualan_detail.penjualan_id = penjualan.id')
            .andWhere('barang.kategori_id', kategori_id);
        });
      }
    }
    return query;
  }

  let baseQuery = db('penjualan')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id');

  baseQuery = applyFilters(baseQuery);

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

  const columns = ['no_nota', 'order_date', 'pelanggan_nama', 'sales_nama', 'subtotal', 'dp', 'bpjs', null, null];
  if (order && order.length > 0) {
    const colIndex = parseInt(order[0].column);
    const dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    if (columns[colIndex]) {
      let orderCol = `penjualan.${columns[colIndex]}`;
      if (columns[colIndex] === 'pelanggan_nama') orderCol = 'pelanggan.nama';
      if (columns[colIndex] === 'sales_nama') orderCol = 'sales.nama';
      baseQuery = baseQuery.orderBy(orderCol, dir);
    } else {
      baseQuery = baseQuery.orderBy('penjualan.order_date', 'desc');
    }
  } else {
    baseQuery = baseQuery.orderBy('penjualan.order_date', 'desc');
  }

  if (length > 0) {
    baseQuery = baseQuery.limit(length).offset(start);
  }

  const data = await baseQuery.select(
    'penjualan.id', 'penjualan.no_nota', 'penjualan.order_date',
    'penjualan.subtotal', 'penjualan.bpjs', 'penjualan.dp', 'penjualan.status_bayar',
    'pelanggan.nama as pelanggan_nama', 'sales.nama as sales_nama'
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
