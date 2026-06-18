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

  var columns = ['order_date', 'no_nota', 'pelanggan_nama', 'total', 'dp', null, 'status_bayar', 'sales_nama'];
  var colToDb = {
    order_date: 'penjualan.order_date', no_nota: 'penjualan.no_nota',
    pelanggan_nama: 'pelanggan.nama', total: 'penjualan.total',
    dp: 'penjualan.dp', status_bayar: 'penjualan.status_bayar',
    sales_nama: 'sales.nama',
  };
  if (order && order.length > 0) {
    var colIndex = parseInt(order[0].column);
    var dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    var colName = columns[colIndex];
    baseQuery = baseQuery.orderBy(colName ? colToDb[colName] : 'penjualan.created_at', dir);
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

exports.findPaymentsByPenjualanId = function (penjualanId) {
  return db('pembayaran_penjualan')
    .select('*')
    .where('penjualan_id', penjualanId)
    .orderBy('tanggal_bayar', 'asc')
    .orderBy('id', 'asc');
};

exports.create = async function (penjualanData, detailItems) {
  return db.transaction(async (trx) => {
    var penjualanArr = await trx('penjualan').insert(penjualanData).returning('*');
    var penjualan = penjualanArr[0];

    // Batch insert all detail items in one query
    var detailRows = detailItems.map(function (item) {
      return {
        penjualan_id: penjualan.id, tipe: item.tipe, barang_id: item.barang_id,
        harga: item.harga || 0, diskon: item.diskon || 0, jumlah: item.jumlah || 1,
        keterangan: item.keterangan || null
      };
    });
    await trx('penjualan_detail').insert(detailRows);

    // Decrement stock separately
    for (var i = 0; i < detailItems.length; i++) {
      var item = detailItems[i];
      if (item.barang_id) {
        var brg = await trx('barang').select('qty').where('id', item.barang_id).first();
        if (brg && brg.qty !== null && brg.qty > 0) {
          await trx('barang').where('id', item.barang_id).decrement('qty', item.jumlah || 1);
        }
      }
    }

    // Auto-create first payment record
    if (penjualanData.status_bayar === 'lunas') {
      await trx('pembayaran_penjualan').insert({
        penjualan_id: penjualan.id, tanggal_bayar: penjualanData.order_date,
        jumlah_bayar: penjualanData.total, keterangan: 'Pembayaran lunas',
      });
    } else if (penjualanData.status_bayar === 'dp' && penjualanData.dp > 0) {
      await trx('pembayaran_penjualan').insert({
        penjualan_id: penjualan.id, tanggal_bayar: penjualanData.order_date,
        jumlah_bayar: penjualanData.dp, keterangan: 'Down Payment',
      });
    }

    // Save komisi sales
    if (penjualanData.sales_id) {
      var frameTotal = 0, lensaTotal = 0;
      for (var j = 0; j < detailItems.length; j++) {
        var line = detailItems[j];
        var lineTotal = (parseFloat(line.harga || 0) - parseFloat(line.diskon || 0)) * parseInt(line.jumlah || 1);
        if (line.tipe === 'frame') frameTotal += lineTotal;
        else if (line.tipe === 'lensa_r' || line.tipe === 'lensa_l') lensaTotal += lineTotal;
      }

      var sales = await trx('sales').where('id', penjualanData.sales_id).first();
      if (sales) {
        var komisiRows = [];
        if (frameTotal > 0 && parseFloat(sales.komisi_frame) > 0) {
          komisiRows.push({
            penjualan_id: penjualan.id, sales_id: sales.id, tipe: 'frame',
            persentase: sales.komisi_frame, nominal_komisi: frameTotal * parseFloat(sales.komisi_frame) / 100
          });
        }
        if (lensaTotal > 0 && parseFloat(sales.komisi_lensa) > 0) {
          komisiRows.push({
            penjualan_id: penjualan.id, sales_id: sales.id, tipe: 'lensa',
            persentase: sales.komisi_lensa, nominal_komisi: lensaTotal * parseFloat(sales.komisi_lensa) / 100
          });
        }
        if (komisiRows.length > 0) await trx('komisi_sales').insert(komisiRows);
      }
    }

    return penjualan;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    // 1. Revert and delete retur (flattened — single query for all retur details)
    var returIds = await trx('penjualan_retur').where('penjualan_id', id).pluck('id');
    if (returIds.length > 0) {
      var returDetails = await trx('penjualan_retur_detail').whereIn('penjualan_retur_id', returIds);
      for (var i = 0; i < returDetails.length; i++) {
        if (returDetails[i].barang_id) {
          await trx('barang').where('id', returDetails[i].barang_id).decrement('qty', returDetails[i].jumlah);
        }
      }
      await trx('penjualan_retur_detail').whereIn('penjualan_retur_id', returIds).del();
      await trx('penjualan_retur').whereIn('id', returIds).del();
    }

    // 2. Revert and delete penjualan details
    var details = await trx('penjualan_detail').where('penjualan_id', id);
    for (var j = 0; j < details.length; j++) {
      if (details[j].barang_id) {
        await trx('barang').where('id', details[j].barang_id).increment('qty', details[j].jumlah);
      }
    }
    await trx('penjualan_detail').where('penjualan_id', id).del();

    // 3. Delete related records and main record
    await trx('komisi_sales').where('penjualan_id', id).del();
    await trx('pembayaran_penjualan').where('penjualan_id', id).del();
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
  const { start, length, search, order, start_date, end_date } = params;

  // Reusable raw expressions for pembayaran subqueries
  const sqlPelunasanDate = db.raw('(SELECT MAX(tanggal_bayar) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id)');
  const sqlTotalBayar = db.raw('((SELECT SUM(jumlah_bayar) FROM pembayaran_penjualan WHERE penjualan_id = penjualan.id) - penjualan.dp)');

  let baseQuery = db('penjualan')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .leftJoin('sales', 'penjualan.sales_id', 'sales.id')
    .where('penjualan.dp', '>', 0)
    .andWhere('penjualan.status_bayar', 'lunas');

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
