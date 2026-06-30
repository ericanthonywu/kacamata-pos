const db = require('../config/database');
const { todayCompact } = require('../utils/date.helper');
const TABLE = 'pembelian';

exports.findAll = function () {
  return db(TABLE)
    .select('pembelian.*', 'supplier.nama as supplier_nama')
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id')
    .orderBy('pembelian.created_at', 'desc');
};

exports.getDatatablesData = async function (params) {
  const { start, length, search, order, start_date, end_date } = params;

  let baseQuery = db(TABLE)
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id');

  const totalCountRes = await baseQuery.clone().count('pembelian.id as count').first();
  const recordsTotal = parseInt(totalCountRes.count);

  if (start_date) baseQuery = baseQuery.where('pembelian.tanggal_pembelian', '>=', start_date);
  if (end_date) baseQuery = baseQuery.where('pembelian.tanggal_pembelian', '<=', end_date);

  if (search && search.value) {
    baseQuery = baseQuery.where(function () {
      this.where('pembelian.kode_pembelian', 'ilike', `%${search.value}%`)
        .orWhere('supplier.nama', 'ilike', `%${search.value}%`)
        .orWhereExists(function () {
          this.select('*')
            .from('pembelian_detail')
            .join('barang', 'pembelian_detail.barang_id', 'barang.id')
            .whereRaw('pembelian_detail.pembelian_id = pembelian.id')
            .andWhere('barang.barcode_id', 'ilike', `%${search.value}%`);
        });
    });
  }

  const filteredCountRes = await baseQuery.clone().count('pembelian.id as count').first();
  const recordsFiltered = parseInt(filteredCountRes.count);

  const sumLunasRes = await baseQuery.clone().where('status_bayar', 'lunas').select(db.raw("SUM(total_harga) as total_pembelian")).first();
  const totalPembelianLunas = sumLunasRes && sumLunasRes.total_pembelian ? parseFloat(sumLunasRes.total_pembelian) : 0;

  const sumBelumLunasRes = await baseQuery.clone().where('status_bayar', '!=', 'lunas').select(db.raw("SUM(total_harga) as total_pembelian")).first();
  const totalPembelianBelumLunas = sumBelumLunasRes && sumBelumLunasRes.total_pembelian ? parseFloat(sumBelumLunasRes.total_pembelian) : 0;

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

  return { recordsTotal, recordsFiltered, data, totalPembelianLunas, totalPembelianBelumLunas };
};

exports.findById = function (id) {
  return db(TABLE)
    .select('pembelian.*', 'supplier.nama as supplier_nama')
    .leftJoin('supplier', 'pembelian.supplier_id', 'supplier.id')
    .where('pembelian.id', id).first();
};

exports.insert = function (trx, data) {
  return trx(TABLE).insert(data).returning('*').then(r => r[0]);
};

exports.update = function (trx, id, data) {
  return trx(TABLE).where('id', id).update(data);
};

exports.deleteById = function (trx, id) {
  return trx(TABLE).where('id', id).del();
};

exports.findByIdWithTrx = function (trx, id) {
  return trx(TABLE).where('id', id).first();
};

exports.generateKodePembelian = async function () {
  const today = todayCompact();
  const prefix = `PI-${today}-`;
  const result = await db(TABLE).where('kode_pembelian', 'like', `${prefix}%`).count('id as cnt').first();
  const seq = (parseInt(result.cnt) || 0) + 1;
  return prefix + String(seq).padStart(4, '0');
};
