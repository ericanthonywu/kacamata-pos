const repo = require('../repositories/barang.repository');
const bhfRepo = require('../repositories/bukti-hitung-fisik.repository');

exports.getAll = function (filters) { return repo.findAll(filters); };
exports.getDatatablesData = function (params) { return repo.getDatatablesData(params); };
exports.getById = function (id) { return repo.findById(id); };
exports.search = function (q, kategori_nama) { return repo.search(q, kategori_nama); };

exports.create = async function (data) {
  if (!data.nama_barang || !data.nama_barang.trim()) throw Object.assign(new Error('Nama barang harus diisi'), { status: 400 });
  const barcode_id = await repo.generateBarcodeId();
  return repo.create({
    nama_barang: data.nama_barang.trim(),
    kategori_id: data.kategori_id || null,
    qty: (data.qty === '' || data.qty === null || data.qty === undefined) ? null : parseInt(data.qty),
    harga_jual: parseFloat(data.harga_jual) || 0,
    sph_r: data.sph_r || null,
    sph_l: data.sph_l || null,
    cyl_r: data.cyl_r || null,
    cyl_l: data.cyl_l || null,
    add_r: data.add_r || null,
    add_l: data.add_l || null,
    barcode_id,
  });
};

exports.update = async function (id, data, options = {}) {
  if (!data.nama_barang || !data.nama_barang.trim()) throw Object.assign(new Error('Nama barang harus diisi'), { status: 400 });

  const { log_hitung_fisik, user_nama } = options;

  // If logging requested, fetch current barang to compare qty
  let oldBarang = null;
  if (log_hitung_fisik) {
    oldBarang = await repo.findById(id);
    if (!oldBarang) throw Object.assign(new Error('Barang tidak ditemukan'), { status: 404 });
  }

  const updateData = {
    nama_barang: data.nama_barang.trim(),
    kategori_id: data.kategori_id || null,
    qty: (data.qty === '' || data.qty === null || data.qty === undefined) ? null : parseInt(data.qty),
    harga_jual: parseFloat(data.harga_jual) || 0,
    sph_r: data.sph_r || null,
    sph_l: data.sph_l || null,
    cyl_r: data.cyl_r || null,
    cyl_l: data.cyl_l || null,
    add_r: data.add_r || null,
    add_l: data.add_l || null,
  };

  const result = await repo.update(id, updateData);

  // Create bukti hitung fisik log if requested and stock actually changed
  if (log_hitung_fisik && oldBarang) {
    const oldQty = oldBarang.qty !== null ? parseInt(oldBarang.qty) : 0;
    const newQty = updateData.qty !== null ? parseInt(updateData.qty) : 0;

    if (oldQty !== newQty) {
      await bhfRepo.create({
        barang_id: id,
        nama_barang: oldBarang.nama_barang,
        barcode_id: oldBarang.barcode_id || '',
        qty_sebelum: oldQty,
        qty_sesudah: newQty,
        selisih: newQty - oldQty,
        diubah_oleh: user_nama || '',
      });
    }
  }

  return result;
};

exports.del = function (id) { return repo.del(id); };
