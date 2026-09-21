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

function isTransientDbError(err) {
  if (!err) return false;
  const msg = (err.message || '').toLowerCase();
  const code = err.code || '';
  return (
    code === 'ECONNRESET' ||
    code === 'ETIMEDOUT' ||
    code === 'EPIPE' ||
    code === '57P01' || // admin_shutdown
    code === '57P02' || // crash_shutdown
    code === '57P03' || // cannot_connect_now
    code === '40P01' || // deadlock_detected
    code === '40001' || // serialization_failure
    msg.includes('connection terminated') ||
    msg.includes('connection ended') ||
    msg.includes('query read timeout') ||
    msg.includes('timeout acquiring a connection') ||
    msg.includes('canceling statement due to statement timeout') ||
    msg.includes('statement timeout')
  );
}

exports.create = async function (data, userId) {
  if (!data.items || data.items.length === 0)
    throw Object.assign(new Error('Minimal satu item harus diisi'), { status: 400 });

  let subtotal = 0;
  const items = data.items.filter(i => i.barang_id || i.tipe === 'lain_lain');

  // --- Stock validation (batched in 1 query) ---
  const qtyMap = {};
  for (const item of items) {
    if (item.barang_id) {
      const id = parseInt(item.barang_id, 10);
      qtyMap[id] = (qtyMap[id] || 0) + (parseInt(item.jumlah, 10) || 1);
    }
  }

  const barangIds = Object.keys(qtyMap).map(id => parseInt(id, 10));
  const existingBarangList = barangIds.length > 0 ? await barangRepo.findByIds(barangIds) : [];
  const barangMap = new Map(existingBarangList.map(b => [b.id, b]));

  for (const barangId of barangIds) {
    if (!barangMap.has(barangId)) {
      throw Object.assign(new Error(`Barang dengan ID ${barangId} tidak ditemukan`), { status: 400 });
    }
  }

  const warnings = [];
  for (const item of items) {
    subtotal += ((parseFloat(item.harga) || 0) - (parseFloat(item.diskon) || 0)) * (parseInt(item.jumlah, 10) || 1);
    if (item.barang_id) {
      const barang = barangMap.get(parseInt(item.barang_id, 10));
      if (barang && barang.qty <= 0) {
        warnings.push(`Pemberitahuan: Stok barang "${barang.nama_barang}" saat ini sedang kosong (0). Transaksi tetap berhasil dicatat.`);
      }
    }
  }

  // Pre-fetch sales if applicable to minimize transaction duration
  let salesRecord = null;
  if (data.sales_id && (data.status_bayar || 'lunas') === 'lunas') {
    salesRecord = await salesRepo.findById(data.sales_id);
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

  const MAX_RETRIES = 2;
  let lastError = null;

  for (let attempt = 0; attempt <= MAX_RETRIES; attempt++) {
    try {
      // Check if previous attempt already committed on database before retrying
      if (attempt > 0) {
        const existing = await penjualanRepo.findByNoNota(no_nota);
        if (existing) {
          const res = await exports.getById(existing.id);
          res.warnings = warnings;
          return res;
        }
        // Small backoff before retry (300ms, 600ms)
        await new Promise(r => setTimeout(r, attempt * 300));
      }

      const penjualan = await db.transaction(async (trx) => {
        // 1. Insert penjualan
        const createdPenjualan = await penjualanRepo.insert(trx, penjualanData);

        // 2. Insert detail items
        const detailRows = items.map(item => ({
          penjualan_id: createdPenjualan.id,
          tipe: item.tipe,
          barang_id: item.barang_id,
          harga: item.harga || 0,
          diskon: item.diskon || 0,
          jumlah: item.jumlah || 1,
          keterangan: item.keterangan || null,
        }));
        await penjualanDetailRepo.insertMany(trx, detailRows);

        // 3. Decrement stock (grouped by unique barang)
        for (const [barangIdStr, totalQty] of Object.entries(qtyMap)) {
          await barangRepo.decrementQty(parseInt(barangIdStr, 10), totalQty, trx);
        }

        // 4. Auto-create first payment + kas record
        if (penjualanData.status_bayar === 'lunas') {
          const pp = await pembayaranPenjualanRepo.insert(trx, {
            penjualan_id: createdPenjualan.id,
            tanggal_bayar: penjualanData.order_date,
            jumlah_bayar: penjualanData.total,
            keterangan: 'Pembayaran lunas',
            metode_bayar_id: penjualanData.metode_bayar_id,
          });
          await kasRepo.insert(trx, {
            tipe: 'masuk', kategori: 'pembayaran_lunas', jumlah: penjualanData.total,
            tanggal: penjualanData.order_date, referensi_id: pp.id, referensi_tipe: 'pembayaran_penjualan',
            penjualan_id: createdPenjualan.id, no_referensi: penjualanData.no_nota, keterangan: 'Pembayaran lunas',
            metode_bayar_id: penjualanData.metode_bayar_id,
          });
        } else if (penjualanData.status_bayar === 'dp' && penjualanData.dp > 0) {
          const pp = await pembayaranPenjualanRepo.insert(trx, {
            penjualan_id: createdPenjualan.id,
            tanggal_bayar: penjualanData.order_date,
            jumlah_bayar: penjualanData.dp,
            keterangan: 'Down Payment',
            metode_bayar_id: penjualanData.metode_bayar_id,
          });
          await kasRepo.insert(trx, {
            tipe: 'masuk', kategori: 'down_payment', jumlah: penjualanData.dp,
            tanggal: penjualanData.order_date, referensi_id: pp.id, referensi_tipe: 'pembayaran_penjualan',
            penjualan_id: createdPenjualan.id, no_referensi: penjualanData.no_nota, keterangan: 'Down Payment',
            metode_bayar_id: penjualanData.metode_bayar_id,
          });
        }

        // 5. Save komisi sales
        if (salesRecord) {
          const komisiRows = buildKomisiRows(createdPenjualan.id, salesRecord, items);
          await komisiSalesRepo.insertMany(trx, komisiRows);
        }

        return createdPenjualan;
      });

      const result = await exports.getById(penjualan.id);
      result.warnings = warnings;
      return result;
    } catch (err) {
      lastError = err;
      if (!isTransientDbError(err) || attempt === MAX_RETRIES) {
        throw err;
      }
      console.warn(`[PenjualanService] Transient DB error on attempt ${attempt + 1}/${MAX_RETRIES + 1} (${err.message}). Retrying...`);
    }
  }

  throw lastError;
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
