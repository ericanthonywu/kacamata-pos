const repo = require('../repositories/sales.repository');
const { todayStr, toDateInput } = require('../utils/date.helper');

function parseKomisi(val) {
  if (val === undefined || val === null || val === '') return 0;
  const num = parseFloat(String(val).replace(',', '.'));
  return isNaN(num) || num < 0 ? 0 : num;
}

exports.getAll = function () { return repo.findAll(); };
exports.getActive = function () { return repo.findActive(); };
exports.getById = function (id) { return repo.findById(id); };

exports.create = function (data) {
  if (!(data.nama || '').trim()) throw Object.assign(new Error('Nama sales harus diisi'), { status: 400 });
  const tgl = toDateInput(data.tanggal_kerja) || todayStr();
  return repo.create({
    nama: data.nama.trim(),
    komisi_frame: parseKomisi(data.komisi_frame),
    komisi_lensa: parseKomisi(data.komisi_lensa),
    tanggal_kerja: tgl,
    status: data.status || 'aktif',
  });
};

exports.update = function (id, data) {
  if (!(data.nama || '').trim()) throw Object.assign(new Error('Nama sales harus diisi'), { status: 400 });
  const payload = {
    nama: data.nama.trim(),
    komisi_frame: parseKomisi(data.komisi_frame),
    komisi_lensa: parseKomisi(data.komisi_lensa),
    status: data.status || 'aktif',
  };
  const tgl = toDateInput(data.tanggal_kerja);
  if (tgl) {
    payload.tanggal_kerja = tgl;
  }
  return repo.update(id, payload);
};
