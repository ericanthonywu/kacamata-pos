const repo = require('../repositories/pelanggan.repository');
const penjualanRepo = require('../repositories/penjualan.repository');

exports.getAll = function () { return repo.findAll(); };
exports.getById = function (id) { return repo.findById(id); };
exports.search = function (q) { return repo.search(q); };

exports.create = async function (data) {
  if (!(data.nama || '').trim()) throw Object.assign(new Error('Nama pelanggan harus diisi'), { status: 400 });
  const nama = data.nama.trim();
  const existing = await repo.findByName(nama);
  if (existing) return existing;
  return repo.create({ nama, no_telp: (data.no_telp || '').trim() || null });
};

exports.update = function (id, data) {
  if (!(data.nama || '').trim()) throw Object.assign(new Error('Nama pelanggan harus diisi'), { status: 400 });
  return repo.update(id, { nama: data.nama.trim(), no_telp: (data.no_telp || '').trim() || null });
};

exports.del = async function (id) {
  const hasData = await penjualanRepo.existsByPelangganId(id);
  if (hasData) {
    throw Object.assign(new Error('Pelanggan tidak bisa dihapus karena masih ada data penjualan yang terkait.'), { status: 400 });
  }
  return repo.del(id);
};
