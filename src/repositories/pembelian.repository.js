const db = require('../config/database');

exports.findAll = function () {
  return db('pembelian')
    .select('pembelian.*', 'supplier.nama as supplier_nama')
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id')
    .orderBy('pembelian.created_at', 'desc');
};

exports.getDatatablesData = async function (params) {
  const { start, length, search, order, start_date, end_date } = params;

  let baseQuery = db('pembelian')
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id');

  const totalCountRes = await baseQuery.clone().count('pembelian.id as count').first();
  const recordsTotal = parseInt(totalCountRes.count);

  if (start_date) baseQuery = baseQuery.where('pembelian.tanggal_pembelian', '>=', start_date);
  if (end_date) baseQuery = baseQuery.where('pembelian.tanggal_pembelian', '<=', end_date);

  if (search && search.value) {
    baseQuery = baseQuery.where(function() {
      this.where('pembelian.kode_pembelian', 'ilike', `%${search.value}%`)
          .orWhere('supplier.nama', 'ilike', `%${search.value}%`);
    });
  }

  const filteredCountRes = await baseQuery.clone().count('pembelian.id as count').first();
  const recordsFiltered = parseInt(filteredCountRes.count);

  const columns = ['kode_pembelian', 'tanggal_pembelian', 'supplier_nama', 'total_harga', 'status_bayar'];
  if (order && order.length > 0) {
    const colIndex = parseInt(order[0].column);
    const dir = order[0].dir === 'desc' ? 'desc' : 'asc';
    if (columns[colIndex]) {
      let orderCol = `pembelian.${columns[colIndex]}`;
      if (columns[colIndex] === 'supplier_nama') orderCol = 'supplier.nama';
      baseQuery = baseQuery.orderBy(orderCol, dir);
    } else {
      baseQuery = baseQuery.orderBy('pembelian.created_at', 'desc');
    }
  } else {
    baseQuery = baseQuery.orderBy('pembelian.created_at', 'desc');
  }

  if (length > 0) {
    baseQuery = baseQuery.limit(length).offset(start);
  }

  const data = await baseQuery.select('pembelian.*', 'supplier.nama as supplier_nama');

  return { recordsTotal, recordsFiltered, data };
};

exports.findById = function (id) {
  return db('pembelian')
    .select('pembelian.*', 'supplier.nama as supplier_nama')
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id')
    .where('pembelian.id', id).first();
};

exports.findDetailsByPembelianId = function (pembelianId) {
  return db('pembelian_detail')
    .select('pembelian_detail.*', 'barang.nama_barang', 'barang.barcode_id', 'barang.harga_jual')
    .leftJoin('barang', 'pembelian_detail.barang_id', 'barang.id')
    .where('pembelian_detail.pembelian_id', pembelianId)
    .orderBy('pembelian_detail.id', 'asc');
};

exports.create = async function (pembelianData, detailItems) {
  return db.transaction(async (trx) => {
    const [pembelian] = await trx('pembelian').insert(pembelianData).returning('*');
    for (const item of detailItems) {
      await trx('pembelian_detail').insert({
        pembelian_id: pembelian.id,
        barang_id: item.barang_id,
        jumlah: item.jumlah || 1,
        harga_beli: item.harga_beli || 0,
      });
      // Increment stock
      if (item.barang_id) {
        const brg = await trx('barang').select('qty').where('id', item.barang_id).first();
        if (brg && brg.qty !== null) {
          await trx('barang').where('id', item.barang_id).increment('qty', item.jumlah || 1);
        }
      }
    }
    // Auto-create payment record if lunas
    if (pembelianData.status_bayar === 'lunas') {
      await trx('pembayaran_pembelian').insert({
        pembelian_id: pembelian.id,
        tanggal_bayar: pembelianData.tanggal_pembelian,
        jumlah_bayar: pembelianData.total_harga,
        keterangan: 'Pembayaran lunas (saat nota dibuat)',
      });
    }
    return pembelian;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    // Restore stock (decrement back)
    const details = await trx('pembelian_detail').where('pembelian_id', id);
    for (const item of details) {
      if (item.barang_id) {
        const brg = await trx('barang').select('qty').where('id', item.barang_id).first();
        if (brg && brg.qty !== null) {
          await trx('barang').where('id', item.barang_id).decrement('qty', item.jumlah);
        }
      }
    }
    await trx('pembelian').where('id', id).del();
  });
};

exports.generateKodePembelian = async function () {
  const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const prefix = `PI-${today}-`;
  const result = await db('pembelian').where('kode_pembelian', 'like', `${prefix}%`).count('id as cnt').first();
  const seq = (parseInt(result.cnt) || 0) + 1;
  return prefix + String(seq).padStart(4, '0');
};
