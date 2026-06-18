const db = require('../config/database');

exports.findAll = function () {
  return db('penjualan')
    .select('penjualan.*', 'pelanggan.nama as pelanggan_nama', 'sales.nama as sales_nama', 'pengguna.nama as created_by_nama')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .leftJoin('pengguna', 'penjualan.created_by', 'pengguna.id')
    .orderBy('penjualan.created_at', 'desc');
};

exports.getDatatablesData = async function (params) {
  const { start, length, search, order, start_date, end_date, status, is_toko } = params;

  let baseQuery = db('penjualan')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .leftJoin('pengguna', 'penjualan.created_by', 'pengguna.id');

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

  const columns = ['order_date', 'no_nota', 'pelanggan_nama', 'total', 'dp', null, 'status_bayar', 'sales_nama'];
  if (order && order.length > 0) {
    const colIndex = parseInt(order[0].column);
    const dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    if (columns[colIndex]) {
      let orderCol = `penjualan.${columns[colIndex]}`;
      if (columns[colIndex] === 'pelanggan_nama') orderCol = 'pelanggan.nama';
      if (columns[colIndex] === 'sales_nama') orderCol = 'sales.nama';
      baseQuery = baseQuery.orderBy(orderCol, dir);
    } else {
      baseQuery = baseQuery.orderBy('penjualan.created_at', 'desc');
    }
  } else {
    baseQuery = baseQuery.orderBy('penjualan.created_at', 'desc');
  }

  if (length > 0) {
    baseQuery = baseQuery.limit(length).offset(start);
  }

  const data = await baseQuery.select('penjualan.*', 'pelanggan.nama as pelanggan_nama', 'sales.nama as sales_nama', 'pengguna.nama as created_by_nama');

  return { recordsTotal, recordsFiltered, data };
};

exports.findById = function (id) {
  return db('penjualan')
    .select('penjualan.*', 'pelanggan.nama as pelanggan_nama', 'pelanggan.no_telp as pelanggan_telp',
      'sales.nama as sales_nama', 'pengguna.nama as created_by_nama')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .leftJoin('pengguna', 'penjualan.created_by', 'pengguna.id')
    .where('penjualan.id', id).first();
};

exports.findDetailsByPenjualanId = function (penjualanId) {
  return db('penjualan_detail')
    .select(
      'penjualan_detail.*',
      'barang.nama_barang',
      'barang.barcode_id',
      'barang.sph_r as b_sph_r', 'barang.cyl_r as b_cyl_r', 'barang.add_r as b_add_r',
      'barang.sph_l as b_sph_l', 'barang.cyl_l as b_cyl_l', 'barang.add_l as b_add_l',
      'kategori.nama as kategori_nama'
    )
    .leftJoin('barang', 'penjualan_detail.barang_id', 'barang.id')
    .leftJoin('kategori', 'barang.kategori_id', 'kategori.id')
    .where('penjualan_detail.penjualan_id', penjualanId)
    .orderBy('penjualan_detail.tipe', 'asc');
};

exports.create = async function (penjualanData, detailItems) {
  return db.transaction(async (trx) => {
    const [penjualan] = await trx('penjualan').insert(penjualanData).returning('*');
    for (const item of detailItems) {
      await trx('penjualan_detail').insert({
        penjualan_id: penjualan.id, tipe: item.tipe, barang_id: item.barang_id,
        harga: item.harga || 0, diskon: item.diskon || 0, jumlah: item.jumlah || 1,
        keterangan: item.keterangan || null
      });
      if (item.barang_id) {
        const brg = await trx('barang').select('qty').where('id', item.barang_id).first();
        if (brg && brg.qty !== null && brg.qty > 0) {
          await trx('barang').where('id', item.barang_id).decrement('qty', item.jumlah || 1);
        }
      }
    }
    // Auto-create first payment record
    if (penjualanData.status_bayar === 'lunas') {
      await trx('pembayaran_penjualan').insert({
        penjualan_id: penjualan.id,
        tanggal_bayar: penjualanData.order_date,
        jumlah_bayar: penjualanData.total,
        keterangan: 'Pembayaran lunas',
      });
    } else if (penjualanData.status_bayar === 'dp' && penjualanData.dp > 0) {
      await trx('pembayaran_penjualan').insert({
        penjualan_id: penjualan.id,
        tanggal_bayar: penjualanData.order_date,
        jumlah_bayar: penjualanData.dp,
        keterangan: 'Down Payment',
      });
    }

    // Save komisi sales
    if (penjualanData.sales_id) {
      let frameTotal = 0;
      let lensaTotal = 0;
      for (const item of detailItems) {
        const lineTotal = (parseFloat(item.harga || 0) - parseFloat(item.diskon || 0)) * parseInt(item.jumlah || 1);
        if (item.tipe === 'frame') frameTotal += lineTotal;
        else if (item.tipe === 'lensa_r' || item.tipe === 'lensa_l') lensaTotal += lineTotal;
      }

      const sales = await trx('sales').where('id', penjualanData.sales_id).first();
      if (sales) {
        if (frameTotal > 0 && parseFloat(sales.komisi_frame) > 0) {
          const nominal = frameTotal * parseFloat(sales.komisi_frame) / 100;
          await trx('komisi_sales').insert({
            penjualan_id: penjualan.id, sales_id: sales.id, tipe: 'frame',
            persentase: sales.komisi_frame, nominal_komisi: nominal
          });
        }
        if (lensaTotal > 0 && parseFloat(sales.komisi_lensa) > 0) {
          const nominal = lensaTotal * parseFloat(sales.komisi_lensa) / 100;
          await trx('komisi_sales').insert({
            penjualan_id: penjualan.id, sales_id: sales.id, tipe: 'lensa',
            persentase: sales.komisi_lensa, nominal_komisi: nominal
          });
        }
      }
    }

    return penjualan;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    // 1. Revert and delete retur
    const returs = await trx('penjualan_retur').where('penjualan_id', id);
    for (const retur of returs) {
      const returDetails = await trx('penjualan_retur_detail').where('penjualan_retur_id', retur.id);
      for (const item of returDetails) {
        if (item.barang_id) {
          await trx('barang').where('id', item.barang_id).decrement('qty', item.jumlah);
        }
      }
      await trx('penjualan_retur_detail').where('penjualan_retur_id', retur.id).del();
      await trx('penjualan_retur').where('id', retur.id).del();
    }

    // 2. Revert and delete penjualan details
    const details = await trx('penjualan_detail').where('penjualan_id', id);
    for (const item of details) {
      if (item.barang_id) {
        await trx('barang').where('id', item.barang_id).increment('qty', item.jumlah);
      }
    }
    await trx('penjualan_detail').where('penjualan_id', id).del();

    // 3. Delete komisi sales
    await trx('komisi_sales').where('penjualan_id', id).del();

    // 4. Delete pembayaran
    await trx('pembayaran_penjualan').where('penjualan_id', id).del();

    // 5. Delete main record
    await trx('penjualan').where('id', id).del();
  });
};

exports.generateNotaNumber = async function () {
  const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const prefix = `INV-${today}-`;
  const result = await db('penjualan').where('no_nota', 'like', `${prefix}%`).count('id as cnt').first();
  const seq = (parseInt(result.cnt) || 0) + 1;
  return prefix + String(seq).padStart(4, '0');
};

exports.getPelunasanDpDatatablesData = async function (params) {
  const { start, length, search, order } = params;

  let baseQuery = db('penjualan')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .where('penjualan.dp', '>', 0)
    .andWhere('penjualan.status_bayar', 'lunas');

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

  const columns = ['no_nota', 'tanggal_pelunasan', 'order_date', 'pelanggan_nama', 'sales_nama', 'total', 'total_bayar'];
  
  // Create a subquery for sorting by pelunasan/bayar
  baseQuery = baseQuery.select(
    'penjualan.id',
    'penjualan.no_nota',
    'penjualan.order_date',
    'pelanggan.nama as pelanggan_nama',
    'sales.nama as sales_nama',
    'penjualan.total',
    db.raw('(SELECT MAX(tanggal_bayar) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id) as tanggal_pelunasan'),
    db.raw('(SELECT SUM(jumlah_bayar) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id) as total_bayar')
  );

  if (order && order.length > 0) {
    const colIndex = parseInt(order[0].column);
    const dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    if (columns[colIndex]) {
      let orderCol = `penjualan.${columns[colIndex]}`;
      if (columns[colIndex] === 'pelanggan_nama') orderCol = 'pelanggan.nama';
      else if (columns[colIndex] === 'sales_nama') orderCol = 'sales.nama';
      else if (columns[colIndex] === 'tanggal_pelunasan') orderCol = db.raw('(SELECT MAX(tanggal_bayar) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id)');
      else if (columns[colIndex] === 'total_bayar') orderCol = db.raw('(SELECT SUM(jumlah_bayar) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id)');
      
      baseQuery = baseQuery.orderBy(orderCol, dir);
    } else {
      baseQuery = baseQuery.orderBy('penjualan.created_at', 'desc');
    }
  } else {
    baseQuery = baseQuery.orderBy('penjualan.created_at', 'desc');
  }

  if (length > 0) {
    baseQuery = baseQuery.limit(length).offset(start);
  }

  const data = await baseQuery;

  return { recordsTotal, recordsFiltered, data };
};
