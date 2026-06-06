const pembelianService = require('../services/pembelian.service');
const supplierService = require('../services/supplier.service');
const barangService = require('../services/barang.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const data = await pembelianService.getAll();
    res.render('pembelian/index', { title: 'Pembelian', data, activePage: 'pembelian' });
  } catch (err) { next(err); }
};

exports.createForm = async function (req, res, next) {
  try {
    const [supplierList, barangList] = await Promise.all([
      supplierService.getAll(),
      barangService.getAll(),
    ]);
    res.render('pembelian/form', {
      title: 'Pembelian Baru',
      supplierList, barangList,
      activePage: 'pembelian',
    });
  } catch (err) { next(err); }
};

exports.store = async function (req, res) {
  try {
    const result = await pembelianService.create(req.body);
    ok(res, result, 201);
  } catch (err) { fail(res, err); }
};

exports.show = async function (req, res) {
  try {
    const data = await pembelianService.getById(req.params.id);
    if (!data) return fail(res, 'Tidak ditemukan', 404);
    ok(res, data);
  } catch (err) { fail(res, err); }
};

exports.destroy = async function (req, res) {
  try {
    await pembelianService.del(req.params.id);
    ok(res);
  } catch (err) { fail(res, err); }
};
