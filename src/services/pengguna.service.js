const bcrypt = require('bcryptjs');
const repo = require('../repositories/pengguna.repository');

exports.getAll = function () { return repo.findAll(); };
exports.getById = function (id) { return repo.findById(id); };

exports.authenticate = async function (username, password) {
  const user = await repo.findByUsername(username);
  if (!user) return null;
  const valid = await bcrypt.compare(password, user.password_hash);
  if (!valid) return null;
  return { id: user.id, nama: user.nama, username: user.username, hak_akses: user.hak_akses };
};

exports.create = async function (data) {
  if (!(data.nama || '').trim() || !(data.username || '').trim() || !data.password)
    throw Object.assign(new Error('Nama, username, dan password harus diisi'), { status: 400 });
  const hash = await bcrypt.hash(data.password, 10);
  return repo.create({
    nama: data.nama.trim(),
    username: data.username.trim(),
    password_hash: hash,
    hak_akses: data.hak_akses || 'kasir',
  });
};

exports.update = async function (id, data) {
  if (!(data.nama || '').trim() || !(data.username || '').trim())
    throw Object.assign(new Error('Nama dan username harus diisi'), { status: 400 });
  const payload = { nama: data.nama.trim(), username: data.username.trim(), hak_akses: data.hak_akses || 'kasir' };
  if (data.password) payload.password_hash = await bcrypt.hash(data.password, 10);
  return repo.update(id, payload);
};

exports.del = function (id) { return repo.del(id); };
