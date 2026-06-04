const repo = require('../repositories/pelanggan.repository');

exports.getAll = function () { return repo.findAll(); };
exports.getById = function (id) { return repo.findById(id); };
exports.search = function (q) { return repo.search(q); };

exports.create = function (data) {
  if (!data.nama?.trim()) throw Object.assign(new Error('Nama pelanggan harus diisi'), { status: 400 });
  return repo.create({ nama: data.nama.trim(), no_telp: data.no_telp?.trim() || null });
};

exports.update = function (id, data) {
  if (!data.nama?.trim()) throw Object.assign(new Error('Nama pelanggan harus diisi'), { status: 400 });
  return repo.update(id, { nama: data.nama.trim(), no_telp: data.no_telp?.trim() || null });
};

exports.del = function (id) { return repo.del(id); };
