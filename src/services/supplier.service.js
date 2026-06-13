const repo = require('../repositories/supplier.repository');

exports.getAll = function () { return repo.findAll(); };
exports.getById = function (id) { return repo.findById(id); };

exports.create = function (data) {
  if (!(data.nama || '').trim()) throw Object.assign(new Error('Nama supplier harus diisi'), { status: 400 });
  return repo.create({ nama: data.nama.trim() });
};

exports.update = function (id, data) {
  if (!(data.nama || '').trim()) throw Object.assign(new Error('Nama supplier harus diisi'), { status: 400 });
  return repo.update(id, { nama: data.nama.trim() });
};

exports.del = function (id) { return repo.del(id); };
