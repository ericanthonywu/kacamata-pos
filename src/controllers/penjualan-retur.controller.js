const returService = require('../services/penjualan-retur.service');
const penjualanService = require('../services/penjualan.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const data = await returService.getAll();
    res.render('penjualan-retur/index', { title: 'Penjualan Retur', data, activePage: 'penjualan-retur' });
  } catch (err) { next(err); }
};

exports.createForm = async function (req, res, next) {
  try {
    const penjualanList = await penjualanService.getAll();
    let selectedPenjualan = null;
    if (req.query.penjualan_id) {
      selectedPenjualan = await penjualanService.getById(req.query.penjualan_id);
    }
    res.render('penjualan-retur/form', {
      title: 'Retur Penjualan Baru',
      penjualanList, selectedPenjualan,
      activePage: 'penjualan-retur',
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

exports.getPenjualanDetail = async function (req, res) {
  try {
    const data = await penjualanService.getById(req.params.id);
    if (!data) return fail(res, 'Tidak ditemukan', 404);
    ok(res, data);
  } catch (err) { fail(res, err); }
};
