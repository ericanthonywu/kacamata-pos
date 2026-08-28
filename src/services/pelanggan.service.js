const repo = require('../repositories/pelanggan.repository');
const penjualanRepo = require('../repositories/penjualan.repository');

exports.getAll = function () { return repo.findAll(); };
exports.getById = function (id) { return repo.findById(id); };
exports.search = function (q) { return repo.search(q); };

exports.create = async function (data) {
  if (!(data.nama || '').trim()) throw Object.assign(new Error('Nama pelanggan harus diisi'), { status: 400 });
  const nama = data.nama.trim();
  const no_telp = (data.no_telp || '').trim() || null;

  const existing = await repo.findByNameAndPhone(nama, no_telp);
  if (existing) return existing;

  return repo.create({ nama, no_telp });
};

exports.update = function (id, data) {
  if (!(data.nama || '').trim()) throw Object.assign(new Error('Nama pelanggan harus diisi'), { status: 400 });
  return repo.update(id, { nama: data.nama.trim(), no_telp: (data.no_telp || '').trim() || null });
};

