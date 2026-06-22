const repo = require('../repositories/metode-pembayaran.repository');

exports.getAll = function ({ includeDeleted = false } = {}) {
  return repo.findAll({ includeDeleted });
};

exports.getById = function (id) {
  return repo.findById(id);
};

exports.create = function (data) {
  if (!data.nama || !data.nama.trim()) throw Object.assign(new Error('Nama metode pembayaran harus diisi'), { status: 400 });
  const tipe = data.tipe === 'cash' ? 'cash' : 'transfer';
  return repo.create({ nama: data.nama.trim(), tipe });
};

exports.update = function (id, data) {
  if (!data.nama || !data.nama.trim()) throw Object.assign(new Error('Nama metode pembayaran harus diisi'), { status: 400 });
  const tipe = data.tipe === 'cash' ? 'cash' : 'transfer';
  return repo.update(id, { nama: data.nama.trim(), tipe });
};

exports.del = function (id) {
  return repo.del(id);
};
