const repo = require('../repositories/barang.repository');
const db = require('../config/database');

exports.getAll = function () { return repo.findAll(); };
exports.getById = function (id) { return repo.findById(id); };
exports.search = function (q) { return repo.search(q); };

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
    qty: parseInt(data.qty) || 0,
    harga_jual: parseFloat(data.harga_jual) || 0,
    barcode_id,
  });
};

exports.update = function (id, data) {
  if (!data.nama_barang || !data.nama_barang.trim()) throw Object.assign(new Error('Nama barang harus diisi'), { status: 400 });
  return repo.update(id, {
    nama_barang: data.nama_barang.trim(),
    kategori_id: data.kategori_id || null,
    qty: parseInt(data.qty) || 0,
    harga_jual: parseFloat(data.harga_jual) || 0,
  });
};

exports.del = function (id) { return repo.del(id); };
