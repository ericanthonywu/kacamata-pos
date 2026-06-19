const repo = require('../repositories/barang.repository');
const db = require('../config/database');

exports.getAll = function (filters) { return repo.findAll(filters); };
exports.getDatatablesData = function (params) { return repo.getDatatablesData(params); };
exports.getById = function (id) { return repo.findById(id); };
exports.search = function (q, kategori_nama) { return repo.search(q, kategori_nama); };

async function generateBarcodeId() {
  const result = await db('barang').max('id as max_id').first();
  const nextId = (result.max_id || 0) + 1;
  return 'BRG-' + String(nextId).padStart(6, '0');
}

exports.create = async function (data) {
  if (!data.nama_barang || !data.nama_barang.trim()) throw Object.assign(new Error('Nama barang harus diisi'), { status: 400 });
  const barcode_id = await generateBarcodeId();
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

exports.update = function (id, data) {
  if (!data.nama_barang || !data.nama_barang.trim()) throw Object.assign(new Error('Nama barang harus diisi'), { status: 400 });
  return repo.update(id, {
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
  });
};

exports.del = function (id) { return repo.del(id); };
