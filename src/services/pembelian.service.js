const db = require('../config/database');
const pembelianRepo = require('../repositories/pembelian.repository');
const pembelianDetailRepo = require('../repositories/pembelian-detail.repository');
const pembayaranPembelianRepo = require('../repositories/pembayaran-pembelian.repository');
const barangRepo = require('../repositories/barang.repository');
const { todayStr } = require('../utils/date.helper');

exports.getAll = function () { return pembelianRepo.findAll(); };
exports.getDatatablesData = function (params) { return pembelianRepo.getDatatablesData(params); };

exports.getById = async function (id) {
  const pembelian = await pembelianRepo.findById(id);
  if (!pembelian) return null;
  const detail = await pembelianDetailRepo.findByPembelianId(id);
  return { ...pembelian, detail };
};

exports.create = async function (data) {
  if (!data.items || data.items.length === 0)
    throw Object.assign(new Error('Minimal satu item harus diisi'), { status: 400 });

  if (!data.supplier_id)
    throw Object.assign(new Error('Supplier harus dipilih'), { status: 400 });

  const items = data.items.filter(i => i.barang_id);
  if (items.length === 0)
    throw Object.assign(new Error('Minimal satu barang harus dipilih'), { status: 400 });

  // Validate all barang exist
  for (const item of items) {
    const barang = await barangRepo.findById(item.barang_id);
    if (!barang) {
      throw Object.assign(new Error(`Barang dengan ID ${item.barang_id} tidak ditemukan`), { status: 400 });
    }
  }

  // Calculate total
  let total_harga = 0;
  for (const item of items) {
    total_harga += (parseFloat(item.harga_beli) || 0) * (parseInt(item.jumlah) || 1);
  }

  const kode_pembelian = await pembelianRepo.generateKodePembelian();

  const pembelianData = {
    kode_pembelian,
    tanggal_pembelian: data.tanggal_pembelian || todayStr(),
    supplier_id: data.supplier_id,
    total_harga,
    status_bayar: data.status_bayar || 'belum_lunas',
  };

  const pembelian = await db.transaction(async (trx) => {
    // 1. Insert pembelian
    const pembelian = await pembelianRepo.insert(trx, pembelianData);

    // 2. Insert details and update stock
    const detailRows = [];
    for (const item of items) {
      detailRows.push({
        pembelian_id: pembelian.id,
        barang_id: item.barang_id,
        jumlah: item.jumlah || 1,
        harga_beli: item.harga_beli || 0,
      });

      // Increment stock and update harga_jual
      if (item.barang_id) {
        const brg = await barangRepo.findByIdWithTrx(trx, item.barang_id);
        if (brg) {
          const updateData = {};
          if (brg.qty !== null) {
            updateData.qty = parseInt(brg.qty) + (item.jumlah || 1);
          }
          if (item.harga_jual !== undefined && item.harga_jual !== null) {
            updateData.harga_jual = item.harga_jual;
          }
          if (Object.keys(updateData).length > 0) {
            await barangRepo.updateFields(trx, item.barang_id, updateData);
          }
        }
      }
    }
    await pembelianDetailRepo.insertMany(trx, detailRows);

    // 3. Auto-create payment record if lunas
    if (pembelianData.status_bayar === 'lunas') {
      await pembayaranPembelianRepo.insert(trx, {
        pembelian_id: pembelian.id,
        tanggal_bayar: pembelianData.tanggal_pembelian,
        jumlah_bayar: pembelianData.total_harga,
        keterangan: 'Pembayaran lunas (saat nota dibuat)',
      });
    }

    return pembelian;
  });

  return exports.getById(pembelian.id);
};

exports.del = async function (id) {
  return db.transaction(async (trx) => {
    // 1. Restore stock (decrement back)
    const details = await pembelianDetailRepo.findRawByPembelianId(trx, id);
    for (const item of details) {
      if (item.barang_id) {
        const brg = await barangRepo.findByIdWithTrx(trx, item.barang_id);
        if (brg && brg.qty !== null) {
          await barangRepo.decrementQty(item.barang_id, item.jumlah, trx);
        }
      }
    }

    // 2. Delete pembelian (cascade via ON DELETE CASCADE or manual)
    await pembelianRepo.deleteById(trx, id);
  });
};
