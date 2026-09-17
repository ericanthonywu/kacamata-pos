const db = require('../config/database');
const barangRepo = require('../repositories/barang.repository');
const { todayStr } = require('../utils/date.helper');

/**
 * In-memory store for incoming transfers received from Pusat (session-based)
 */
const incomingTransfers = [];

/**
 * Get configuration for connecting to Pusat app
 */
exports.getPusatConfig = function () {
  let rawUrl = process.env.PUSAT_APP_URL || process.env.EXTERNAL_STOCK_APP_URL || 'http://localhost:9090';
  rawUrl = rawUrl.trim().replace(/\/$/, '');
  let apiUrl = rawUrl;
  if (!apiUrl.includes('/api/stock-transfer')) {
    apiUrl = apiUrl + '/api/stock-transfer';
  }
  return {
    configured: Boolean(process.env.PUSAT_APP_URL || process.env.EXTERNAL_STOCK_APP_URL),
    url: apiUrl,
    host: rawUrl.replace('/api/stock-transfer', '')
  };
};

/**
 * Returns formatted list of local barang for Pusat's inter-app query
 * Endpoint: GET /api/stock-transfer/items
 */
exports.getExportItems = async function () {
  const items = await barangRepo.findAll();
  return items.map(b => ({
    id: b.id,
    nama_barang: b.nama_barang,
    barcode_id: b.barcode_id || '',
    category: b.kategori_nama || 'Umum',
    stock: b.qty,
    sph_r: b.sph_r || null,
    sph_l: b.sph_l || null,
    cyl_r: b.cyl_r || null,
    cyl_l: b.cyl_l || null,
    add_r: b.add_r || null,
    add_l: b.add_l || null
  }));
};

/**
 * Get list of incoming transfers received from Pusat
 */
exports.getIncomingTransfers = function () {
  return incomingTransfers;
};

/**
 * Process incoming transfer payload sent from Pusat
 * Endpoint: POST /api/stock-transfer/receive
 */
exports.receiveTransfer = async function (data) {
  const rawItems = Array.isArray(data.items) ? data.items : [];
  if (rawItems.length === 0) {
    throw Object.assign(new Error('Daftar barang transfer kosong'), { status: 400 });
  }

  return db.transaction(async function (trx) {
    const results = [];

    for (let i = 0; i < rawItems.length; i++) {
      const item = rawItems[i];
      const qty = parseInt(item.qty, 10);
      if (!qty || isNaN(qty) || qty <= 0) continue;

      // Match item in this branch by external_barang_id or local_barang_id or barcode_id
      let targetBarang = null;
      const candidateId = parseInt(item.external_barang_id || item.local_barang_id, 10);
      if (candidateId && !isNaN(candidateId)) {
        targetBarang = await barangRepo.findById(candidateId, trx);
      }

      if (!targetBarang) {
        throw Object.assign(
          new Error(`Barang tujuan "${item.nama_barang || candidateId}" tidak ditemukan di cabang`),
          { status: 404 }
        );
      }

      // Increment stock in branch
      await barangRepo.incrementQty(targetBarang.id, qty, trx);
      const updatedBarang = await barangRepo.findById(targetBarang.id, trx);

      results.push({
        barang_id: targetBarang.id,
        nama_barang: targetBarang.nama_barang,
        barcode_id: targetBarang.barcode_id,
        qty: qty,
        old_qty: targetBarang.qty,
        new_qty: updatedBarang.qty
      });
    }

    const totalQty = results.reduce((sum, r) => sum + r.qty, 0);
    const transferRecord = {
      id: 'TRF-IN-' + Date.now(),
      tanggal: todayStr(),
      time: new Date().toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit', second: '2-digit' }),
      source: data.source || 'Optik Sentral Pusat',
      notes: data.notes || '',
      total_items: results.length,
      total_qty: totalQty,
      items: results
    };

    incomingTransfers.unshift(transferRecord);

    return {
      success: true,
      transfer_id: transferRecord.id,
      total_items: results.length,
      total_qty: totalQty,
      results: results,
      message: `Berhasil menerima ${results.length} barang (total ${totalQty} pcs) dari Pusat.`
    };
  });
};
