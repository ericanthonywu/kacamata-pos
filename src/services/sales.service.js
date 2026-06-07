const repo = require('../repositories/sales.repository');

exports.getAll = function () { return repo.findAll(); };
exports.getActive = function () { return repo.findActive(); };
exports.getById = function (id) { return repo.findById(id); };

exports.create = function (data) {
  if (!data.nama?.trim()) throw Object.assign(new Error('Nama sales harus diisi'), { status: 400 });
  return repo.create({
    nama: data.nama.trim(),
    komisi_frame: parseFloat(data.komisi_frame) || 0,
    komisi_lensa: parseFloat(data.komisi_lensa) || 0,
    tanggal_kerja: data.tanggal_kerja || new Date().toISOString().split('T')[0],
    status: data.status || 'aktif',
  });
};

exports.update = function (id, data) {
  if (!data.nama?.trim()) throw Object.assign(new Error('Nama sales harus diisi'), { status: 400 });
  return repo.update(id, {
    nama: data.nama.trim(),
    komisi_frame: parseFloat(data.komisi_frame) || 0,
    komisi_lensa: parseFloat(data.komisi_lensa) || 0,
    tanggal_kerja: data.tanggal_kerja,
    status: data.status || 'aktif',
  });
};

exports.del = function (id) { return repo.del(id); };
