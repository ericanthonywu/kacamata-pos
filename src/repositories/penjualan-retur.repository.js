const db = require('../config/database');

exports.findAll = function () {
  return db('penjualan_retur')
    .select('penjualan_retur.*', 'penjualan.no_nota', 'pelanggan.nama as pelanggan_nama')
    .leftJoin('penjualan', 'penjualan_retur.penjualan_id', 'penjualan.id')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .orderBy('penjualan_retur.created_at', 'desc');
};

exports.findById = function (id) {
  return db('penjualan_retur')
    .select('penjualan_retur.*', 'penjualan.no_nota', 'pelanggan.nama as pelanggan_nama')
    .leftJoin('penjualan', 'penjualan_retur.penjualan_id', 'penjualan.id')
    .leftJoin('pelanggan', 'penjualan.pelanggan_id', 'pelanggan.id')
    .where('penjualan_retur.id', id).first();
};

exports.findDetailsByReturId = function (returId) {
  return db('penjualan_retur_detail')
    .select('penjualan_retur_detail.*', 'barang.nama_barang', 'barang.barcode_id')
    .leftJoin('barang', 'penjualan_retur_detail.barang_id', 'barang.id')
    .where('penjualan_retur_detail.penjualan_retur_id', returId)
    .orderBy('penjualan_retur_detail.id', 'asc');
};

/**
 * Recalculate and restore komisi_sales for a penjualan (used when retur is deleted).
 */
async function restoreKomisi(trx, penjualanId) {
  const penjualan = await trx('penjualan').where('id', penjualanId).first();
  if (!penjualan || penjualan.status_bayar !== 'lunas' || !penjualan.sales_id) return;

  const sales = await trx('sales').where('id', penjualan.sales_id).first();
  if (!sales) return;

  const detailItems = await trx('penjualan_detail').where('penjualan_id', penjualanId);
  var frameTotal = 0, lensaTotal = 0;
  for (var i = 0; i < detailItems.length; i++) {
    var line = detailItems[i];
    var lineTotal = (parseFloat(line.harga || 0) - parseFloat(line.diskon || 0)) * parseInt(line.jumlah || 1);
    if (line.tipe === 'frame') frameTotal += lineTotal;
    else if (line.tipe === 'lensa_r' || line.tipe === 'lensa_l') lensaTotal += lineTotal;
  }

  await trx('komisi_sales').where('penjualan_id', penjualanId).del();

  var komisiRows = [];
  if (frameTotal > 0 && parseFloat(sales.komisi_frame) > 0) {
    komisiRows.push({
      penjualan_id: penjualanId, sales_id: sales.id, tipe: 'frame',
      persentase: sales.komisi_frame, nominal_komisi: frameTotal * parseFloat(sales.komisi_frame) / 100
    });
  }
  if (lensaTotal > 0 && parseFloat(sales.komisi_lensa) > 0) {
    komisiRows.push({
      penjualan_id: penjualanId, sales_id: sales.id, tipe: 'lensa',
      persentase: sales.komisi_lensa, nominal_komisi: lensaTotal * parseFloat(sales.komisi_lensa) / 100
    });
  }
  if (komisiRows.length > 0) await trx('komisi_sales').insert(komisiRows);
}

exports.create = async function (returData, detailItems) {
  return db.transaction(async (trx) => {
    const [retur] = await trx('penjualan_retur').insert(returData).returning('*');
    for (const item of detailItems) {
      await trx('penjualan_retur_detail').insert({
        penjualan_retur_id: retur.id,
        barang_id: item.barang_id,
        tipe: item.tipe || 'frame',
        jumlah: item.jumlah || 1,
        harga: item.harga || 0,
      });
      // Increment stock (items returned from customer)
      if (item.barang_id) {
        await trx('barang').where('id', item.barang_id).increment('qty', item.jumlah || 1);
      }
    }

    // Record in kas ledger (cash out)
    await trx('kas').insert({
      tipe: 'keluar',
      kategori: 'retur_penjualan',
      jumlah: retur.total_retur,
      tanggal: retur.tanggal_retur,
      referensi_id: retur.id,
      referensi_tipe: 'penjualan_retur',
      penjualan_id: returData.penjualan_id,
      no_referensi: retur.kode_retur,
      keterangan: 'Retur Penjualan',
    });

    // Hapus komisi sales karena penjualan diretur
    await trx('komisi_sales').where('penjualan_id', returData.penjualan_id).del();

    return retur;
  });
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    // Get penjualan_id before deleting the retur
    const retur = await trx('penjualan_retur').where('id', id).first();
    const penjualanId = retur ? retur.penjualan_id : null;

    const details = await trx('penjualan_retur_detail').where('penjualan_retur_id', id);
    for (const item of details) {
      if (item.barang_id) {
        await trx('barang').where('id', item.barang_id).decrement('qty', item.jumlah);
      }
    }

    // Remove from kas ledger
    await trx('kas')
      .where('referensi_id', id)
      .where('referensi_tipe', 'penjualan_retur')
      .del();

    await trx('penjualan_retur_detail').where('penjualan_retur_id', id).del();
    await trx('penjualan_retur').where('id', id).del();

    // Restore komisi sales setelah retur dihapus
    if (penjualanId) {
      await restoreKomisi(trx, penjualanId);
    }
  });
};

exports.generateKodeRetur = async function () {
  const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const prefix = `RJ-${today}-`;
  const result = await db('penjualan_retur').where('kode_retur', 'like', `${prefix}%`).count('id as cnt').first();
  const seq = (parseInt(result.cnt) || 0) + 1;
  return prefix + String(seq).padStart(4, '0');
};
