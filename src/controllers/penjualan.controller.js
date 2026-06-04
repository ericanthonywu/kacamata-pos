const penjualanService = require('../services/penjualan.service');
const pelangganService = require('../services/pelanggan.service');
const salesService = require('../services/sales.service');
const barangService = require('../services/barang.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const data = await penjualanService.getAll();
    res.render('penjualan/index', { title: 'Penjualan', data, activePage: 'penjualan' });
  } catch (err) { next(err); }
};

exports.createForm = async function (req, res, next) {
  try {
    const [pelanggan, salesList, barangList] = await Promise.all([
      pelangganService.getAll(),
      salesService.getActive(),
      barangService.getAll(),
    ]);
    res.render('penjualan/form', {
      title: 'Penjualan Baru',
      pelanggan, salesList, barangList,
      activePage: 'penjualan',
    });
  } catch (err) { next(err); }
};

exports.store = async function (req, res) {
  try {
    const result = await penjualanService.create(req.body, req.session.user.id);
    ok(res, result, 201);
  } catch (err) { fail(res, err); }
};

exports.show = async function (req, res) {
  try {
    const data = await penjualanService.getById(req.params.id);
    if (!data) return fail(res, 'Tidak ditemukan', 404);
    ok(res, data);
  } catch (err) { fail(res, err); }
};

exports.destroy = async function (req, res) {
  try {
    await penjualanService.del(req.params.id);
    ok(res);
  } catch (err) { fail(res, err); }
};
