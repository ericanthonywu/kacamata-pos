const returService = require('../services/pembelian-retur.service');
const pembelianService = require('../services/pembelian.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const data = await returService.getAll();
    res.render('pembelian-retur/index', { title: 'Pembelian Retur', data, activePage: 'pembelian-retur' });
  } catch (err) { next(err); }
};

exports.createForm = async function (req, res, next) {
  try {
    const pembelianList = await pembelianService.getAll();
    let selectedPembelian = null;
    if (req.query.pembelian_id) {
      selectedPembelian = await pembelianService.getById(req.query.pembelian_id);
    }
    res.render('pembelian-retur/form', {
      title: 'Retur Pembelian Baru',
      pembelianList, selectedPembelian,
      activePage: 'pembelian-retur',
    });
  } catch (err) { next(err); }
};

exports.store = async function (req, res) {
  try {
    const result = await returService.create(req.body);
    ok(res, result, 201);
  } catch (err) { fail(res, err); }
};

exports.show = async function (req, res) {
  try {
    const data = await returService.getById(req.params.id);
    if (!data) return fail(res, 'Tidak ditemukan', 404);
    ok(res, data);
  } catch (err) { fail(res, err); }
};

exports.destroy = async function (req, res) {
  try {
    await returService.del(req.params.id);
    ok(res);
  } catch (err) { fail(res, err); }
};

// API: get pembelian detail for retur form
exports.getPembelianDetail = async function (req, res) {
  try {
    const data = await pembelianService.getById(req.params.id);
    if (!data) return fail(res, 'Tidak ditemukan', 404);
    ok(res, data);
  } catch (err) { fail(res, err); }
};
