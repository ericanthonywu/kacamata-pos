const repo = require('../repositories/barang.repository');

exports.getAll = function () { return repo.findAll(); };
exports.getById = function (id) { return repo.findById(id); };
exports.search = function (q) { return repo.search(q); };

exports.create = function (data) {
  if (!data.nama_barang || !data.nama_barang.trim()) throw Object.assign(new Error('Nama barang harus diisi'), { status: 400 });
  return repo.create({
    nama_barang: data.nama_barang.trim(),
    kategori_id: data.kategori_id || null,
    qty: parseInt(data.qty) || 0,
    harga_jual: parseFloat(data.harga_jual) || 0,
    barcode_id: data.barcode_id?.trim() || null,
  });
};

exports.update = function (id, data) {
  if (!data.nama_barang || !data.nama_barang.trim()) throw Object.assign(new Error('Nama barang harus diisi'), { status: 400 });
  return repo.update(id, {
    nama_barang: data.nama_barang.trim(),
    kategori_id: data.kategori_id || null,
    qty: parseInt(data.qty) || 0,
    harga_jual: parseFloat(data.harga_jual) || 0,
    barcode_id: data.barcode_id?.trim() || null,
  });
};

exports.del = function (id) { return repo.del(id); };
