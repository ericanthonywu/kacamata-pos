const repo = require('../repositories/kategori.repository');

exports.getAll = function (cabangId) { return repo.findAll(cabangId); };
exports.getById = function (id) { return repo.findById(id); };

exports.create = function (data, userCabangId) {
  if (!data.nama || !data.nama.trim()) throw Object.assign(new Error('Nama kategori harus diisi'), { status: 400 });
  return repo.create({ nama: data.nama.trim(), cabang_id: userCabangId || 1 });
};

exports.update = function (id, data) {
  if (!data.nama || !data.nama.trim()) throw Object.assign(new Error('Nama kategori harus diisi'), { status: 400 });
  return repo.update(id, { nama: data.nama.trim() });
};
