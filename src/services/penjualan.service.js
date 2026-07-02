const db = require('../config/database');
const penjualanRepo = require('../repositories/penjualan.repository');
const penjualanDetailRepo = require('../repositories/penjualan-detail.repository');
const pembayaranPenjualanRepo = require('../repositories/pembayaran-penjualan.repository');
const kasRepo = require('../repositories/kas.repository');
const komisiSalesRepo = require('../repositories/komisi-sales.repository');
const penjualanReturRepo = require('../repositories/penjualan-retur.repository');
const penjualanReturDetailRepo = require('../repositories/penjualan-retur-detail.repository');
const barangRepo = require('../repositories/barang.repository');
const salesRepo = require('../repositories/sales.repository');
const { buildKomisiRows } = require('../utils/komisi.helper');
const { todayStr } = require('../utils/date.helper');

exports.getAll = function () { return penjualanRepo.findAll(); };
exports.getDatatablesData = function (params) { return penjualanRepo.getDatatablesData(params); };
exports.getPelunasanDpDatatables = function (params) { return penjualanRepo.getPelunasanDpDatatablesData(params); };

exports.getById = async function (id) {
  const penjualan = await penjualanRepo.findById(id);
  if (!penjualan) return null;
  const [detail, pembayaran] = await Promise.all([
    penjualanDetailRepo.findByPenjualanId(id),
    pembayaranPenjualanRepo.findByPenjualanId(id),
  ]);
  return { ...penjualan, detail, pembayaran };
};

exports.create = async function (data, userId) {
  if (!data.items || data.items.length === 0)
    throw Object.assign(new Error('Minimal satu item harus diisi'), { status: 400 });

  let subtotal = 0;
  const items = data.items.filter(i => i.barang_id || i.tipe === 'lain_lain');

  // --- Stock validation ---
  const qtyMap = {};
  for (const item of items) {
    if (item.barang_id) {
      const id = item.barang_id;
      qtyMap[id] = (qtyMap[id] || 0) + (parseInt(item.jumlah) || 1);
    }
  }

  for (const [barangId] of Object.entries(qtyMap)) {
    const barang = await barangRepo.findById(barangId);
    if (!barang) {
      throw Object.assign(new Error(`Barang dengan ID ${barangId} tidak ditemukan`), { status: 400 });
    }
  }

  const warnings = [];
  for (const item of items) {
    subtotal += ((parseFloat(item.harga) || 0) - (parseFloat(item.diskon) || 0)) * (parseInt(item.jumlah) || 1);
    if (item.barang_id) {
      const barang = await barangRepo.findById(item.barang_id);
      if (barang && barang.qty !== null && barang.qty <= 0) {
        warnings.push(`Pemberitahuan: Stok barang "${barang.nama_barang}" saat ini sedang kosong (0). Transaksi tetap berhasil dicatat.`);
      }
    }
  }

  const bpjsAmount = parseFloat(data.bpjs) || 0;
  const total = subtotal - bpjsAmount;
  const no_nota = await penjualanRepo.generateNotaNumber(data.is_b2b);

  const penjualanData = {
    no_nota,
    pelanggan_id: data.pelanggan_id || null,
    sales_id: data.sales_id || null,
    created_by: userId === 0 ? null : userId,
    order_date: data.order_date || todayStr(),
    tanggal_selesai: data.tanggal_selesai || null,
    biaya: 0,
    subtotal,
    bpjs: bpjsAmount,
    total,
    status_bayar: data.status_bayar || 'lunas',
    dp: parseFloat(data.dp) || 0,
    sph_r: data.sph_r || null,
    sph_l: data.sph_l || null,
    cyl_r: data.cyl_r || null,
    cyl_l: data.cyl_l || null,
    axis_r: data.axis_r || null,
    axis_l: data.axis_l || null,
    add_r: data.add_r || null,
    add_l: data.add_l || null,
    pd: data.pd || null,
    is_b2b: data.is_b2b || false,
    metode_bayar_id: data.metode_bayar || null,
  };

  const penjualan = await db.transaction(async (trx) => {
    // 1. Insert penjualan
    const penjualan = await penjualanRepo.insert(trx, penjualanData);

    // 2. Insert detail items
    const detailRows = items.map(item => ({
      penjualan_id: penjualan.id,
      tipe: item.tipe,
      barang_id: item.barang_id,
      harga: item.harga || 0,
      diskon: item.diskon || 0,
      jumlah: item.jumlah || 1,
      keterangan: item.keterangan || null,
    }));
    await penjualanDetailRepo.insertMany(trx, detailRows);

    // 3. Decrement stock
    for (const item of items) {
      if (item.barang_id) {
        const brg = await barangRepo.findByIdWithTrx(trx, item.barang_id);
        if (brg && brg.qty !== null) {
          await barangRepo.decrementQty(item.barang_id, item.jumlah || 1, trx);
        }
      }
    }

    // 4. Auto-create first payment + kas record
    if (penjualanData.status_bayar === 'lunas') {
      const pp = await pembayaranPenjualanRepo.insert(trx, {
        penjualan_id: penjualan.id,
        tanggal_bayar: penjualanData.order_date,
        jumlah_bayar: penjualanData.total,
        keterangan: 'Pembayaran lunas',
        metode_bayar_id: penjualanData.metode_bayar_id,
      });
      await kasRepo.insert(trx, {
        tipe: 'masuk', kategori: 'pembayaran_lunas', jumlah: penjualanData.total,
        tanggal: penjualanData.order_date, referensi_id: pp.id, referensi_tipe: 'pembayaran_penjualan',
        penjualan_id: penjualan.id, no_referensi: penjualanData.no_nota, keterangan: 'Pembayaran lunas',
        metode_bayar_id: penjualanData.metode_bayar_id,
      });
    } else if (penjualanData.status_bayar === 'dp' && penjualanData.dp > 0) {
      const pp = await pembayaranPenjualanRepo.insert(trx, {
        penjualan_id: penjualan.id,
        tanggal_bayar: penjualanData.order_date,
        jumlah_bayar: penjualanData.dp,
        keterangan: 'Down Payment',
        metode_bayar_id: penjualanData.metode_bayar_id,
      });
      await kasRepo.insert(trx, {
        tipe: 'masuk', kategori: 'down_payment', jumlah: penjualanData.dp,
        tanggal: penjualanData.order_date, referensi_id: pp.id, referensi_tipe: 'pembayaran_penjualan',
        penjualan_id: penjualan.id, no_referensi: penjualanData.no_nota, keterangan: 'Down Payment',
        metode_bayar_id: penjualanData.metode_bayar_id,
      });
    }

    // 5. Save komisi sales
    if (penjualanData.sales_id && penjualanData.status_bayar === 'lunas') {
      const sales = await salesRepo.findById(penjualanData.sales_id);
      if (sales) {
        const komisiRows = buildKomisiRows(penjualan.id, sales, items);
        await komisiSalesRepo.insertMany(trx, komisiRows);
      }
    }

    return penjualan;
  });

  const result = await exports.getById(penjualan.id);
  result.warnings = warnings;
  return result;
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    // 1. Revert and delete retur
    const returIds = await penjualanReturRepo.pluckIdsByPenjualanId(trx, id);
    if (returIds.length > 0) {
      const returDetails = await penjualanReturDetailRepo.findRawByReturIds(trx, returIds);
      for (const rd of returDetails) {
        if (rd.barang_id) {
          await barangRepo.decrementQty(rd.barang_id, rd.jumlah, trx);
        }
      }
      await penjualanReturDetailRepo.deleteByReturIds(trx, returIds);
      await penjualanReturRepo.deleteByIds(trx, returIds);
    }

    // 2. Revert and delete penjualan details
    const details = await penjualanDetailRepo.findRawByPenjualanId(id, trx);
    for (const d of details) {
      if (d.barang_id) {
        await barangRepo.incrementQty(d.barang_id, d.jumlah, trx);
      }
    }
    await penjualanDetailRepo.deleteByPenjualanId(trx, id);

    // 3. Delete related records and main record
    await komisiSalesRepo.deleteByPenjualanId(trx, id);
    await kasRepo.deleteByPenjualanId(trx, id);
    await pembayaranPenjualanRepo.deleteByPenjualanId(trx, id);
    await penjualanRepo.deleteById(trx, id);
  });
};

exports.updateMetodePembayaran = async function (id, metode_bayar_id) {
  return db.transaction(async (trx) => {
    const val = metode_bayar_id || null;
    await penjualanRepo.update(trx, id, { metode_bayar_id: val });
    await pembayaranPenjualanRepo.updateMetodeBayarWhereNull(trx, id, val);
    await kasRepo.updateMetodeBayarWhereNull(trx, id, val);
  });
};
