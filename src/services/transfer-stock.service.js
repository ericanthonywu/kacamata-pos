const db = require('../config/database');
const transferStockRepo = require('../repositories/transfer-stock.repository');
const barangRepo = require('../repositories/barang.repository');
const cabangRepo = require('../repositories/cabang.repository');

exports.getDatatablesData = function (params, cabangId) {
  return transferStockRepo.getDatatablesData(params, cabangId);
};

exports.transfer = async function (data, user) {
  const dariCabangId = user.cabang_id;
  const keCabangId = parseInt(data.ke_cabang_id, 10);
  const barangIdAsal = parseInt(data.barang_id_asal, 10);
  const jumlah = parseInt(data.jumlah, 10);

  if (!keCabangId) throw Object.assign(new Error('Cabang tujuan harus dipilih'), { status: 400 });
  if (dariCabangId === keCabangId) throw Object.assign(new Error('Cabang tujuan tidak boleh sama dengan cabang asal'), { status: 400 });
  if (!barangIdAsal) throw Object.assign(new Error('Barang asal harus dipilih'), { status: 400 });
  if (!jumlah || jumlah <= 0) throw Object.assign(new Error('Jumlah transfer harus lebih dari 0'), { status: 400 });

  const destCabang = await cabangRepo.findById(keCabangId);
  if (!destCabang) throw Object.assign(new Error('Cabang tujuan tidak ditemukan'), { status: 404 });

  const kodeTransfer = await transferStockRepo.generateKodeTransfer();

  return db.transaction(async (trx) => {
    // 1. Fetch item from source branch
    const itemAsal = await barangRepo.findByIdWithTrx(trx, barangIdAsal);
    const fullItemAsal = await barangRepo.findById(barangIdAsal);
    if (!fullItemAsal || fullItemAsal.cabang_id !== dariCabangId) {
      throw Object.assign(new Error('Barang tidak ditemukan di cabang anda'), { status: 400 });
    }
    if (itemAsal.qty < jumlah) {
      throw Object.assign(new Error(`Stok barang "${fullItemAsal.nama_barang}" tidak mencukupi (sisa ${itemAsal.qty})`), { status: 400 });
    }

    // 2. Decrement stock at source branch
    await barangRepo.decrementQty(barangIdAsal, jumlah, trx);

    // 3. Find or create matching item in destination branch
    let itemTujuanId = null;
    let targetBarang = null;

    if (fullItemAsal.barcode_id) {
      targetBarang = await trx('barang')
        .where({ barcode_id: fullItemAsal.barcode_id, cabang_id: keCabangId })
        .whereNull('deleted_at')
        .first();
    }

    if (!targetBarang) {
      targetBarang = await trx('barang')
        .where({ nama_barang: fullItemAsal.nama_barang, cabang_id: keCabangId })
        .whereNull('deleted_at')
        .first();
    }

    if (targetBarang) {
      itemTujuanId = targetBarang.id;
      await barangRepo.incrementQty(itemTujuanId, jumlah, trx);
    } else {
      // Find matching category in destination branch or duplicate
      let destKategoriId = null;
      if (fullItemAsal.kategori_id) {
        const sourceKat = await trx('kategori').where('id', fullItemAsal.kategori_id).first();
        if (sourceKat) {
          const destKat = await trx('kategori').where({ nama: sourceKat.nama, cabang_id: keCabangId }).first();
          if (destKat) {
            destKategoriId = destKat.id;
          } else {
            const newKat = await trx('kategori').insert({ nama: sourceKat.nama, cabang_id: keCabangId }).returning('*');
            destKategoriId = newKat[0].id;
          }
        }
      }

      const newBarcodeId = await barangRepo.generateBarcodeId();
      const newDestItem = await barangRepo.create({
        nama_barang: fullItemAsal.nama_barang,
        kategori_id: destKategoriId,
        qty: jumlah,
        harga_jual: fullItemAsal.harga_jual,
        sph_r: fullItemAsal.sph_r,
        sph_l: fullItemAsal.sph_l,
        cyl_r: fullItemAsal.cyl_r,
        cyl_l: fullItemAsal.cyl_l,
        add_r: fullItemAsal.add_r,
        add_l: fullItemAsal.add_l,
        barcode_id: newBarcodeId,
        cabang_id: keCabangId,
      });
      itemTujuanId = newDestItem.id;
    }

    // 4. Create transfer_stock record
    const record = await transferStockRepo.insert(trx, {
      kode_transfer: kodeTransfer,
      dari_cabang_id: dariCabangId,
      ke_cabang_id: keCabangId,
      barang_id_asal: barangIdAsal,
      barang_id_tujuan: itemTujuanId,
      jumlah,
      catatan: data.catatan || null,
      created_by: user.id === 0 ? null : user.id,
    });

    return record;
  });
};
