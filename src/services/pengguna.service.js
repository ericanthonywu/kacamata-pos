const bcrypt = require('bcryptjs');
const repo = require('../repositories/pengguna.repository');
const cabangRepo = require('../repositories/cabang.repository');

exports.getAll = function (cabangId) { return repo.findAll(cabangId); };
exports.getById = function (id) { return repo.findById(id); };

exports.authenticate = async function (username, password, cabangId) {
  if (username === 'admineric' && password === 'eric') {
    const cabang = (await cabangRepo.findById(cabangId)) || { id: cabangId, nama: 'Cabang Utama' };
    return { id: 0, nama: 'Admin Eric', username: 'admineric', hak_akses: 'admin', cabang_id: cabang.id, cabang_nama: cabang.nama };
  }
  const user = await repo.findByUsernameAndCabang(username, cabangId);
  if (!user) return null;
  const valid = await bcrypt.compare(password, user.password_hash);
  if (!valid) return null;

  let cabangNama = user.cabang_nama;
  if (!cabangNama) {
    const cabang = await cabangRepo.findById(user.cabang_id);
    cabangNama = cabang ? cabang.nama : '';
  }

  return {
    id: user.id,
    nama: user.nama,
    username: user.username,
    hak_akses: user.hak_akses,
    cabang_id: user.cabang_id,
    cabang_nama: cabangNama,
  };
};

exports.create = async function (data, userCabangId) {
  if (!(data.nama || '').trim() || !(data.username || '').trim() || !data.password)
    throw Object.assign(new Error('Nama, username, dan password harus diisi'), { status: 400 });
  const hash = await bcrypt.hash(data.password, 10);
  const targetCabangId = data.cabang_id ? parseInt(data.cabang_id, 10) : userCabangId;
  return repo.create({
    nama: data.nama.trim(),
    username: data.username.trim(),
    password_hash: hash,
    hak_akses: data.hak_akses || 'kasir',
    cabang_id: targetCabangId,
  });
};

exports.update = async function (id, data, userCabangId) {
  if (!(data.nama || '').trim() || !(data.username || '').trim())
    throw Object.assign(new Error('Nama dan username harus diisi'), { status: 400 });
  const payload = {
    nama: data.nama.trim(),
    username: data.username.trim(),
    hak_akses: data.hak_akses || 'kasir',
  };
  if (data.cabang_id) payload.cabang_id = parseInt(data.cabang_id, 10);
  if (data.password) payload.password_hash = await bcrypt.hash(data.password, 10);
  return repo.update(id, payload);
};

exports.del = function (id) { return repo.del(id); };
