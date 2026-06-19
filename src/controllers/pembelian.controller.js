const pembelianService = require('../services/pembelian.service');
const supplierService = require('../services/supplier.service');
const barangService = require('../services/barang.service');
const kategoriService = require('../services/kategori.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    res.render('pembelian/index', { title: 'Pembelian', activePage: 'pembelian' });
  } catch (err) { next(err); }
};

exports.datatables = async function (req, res) {
  try {
    const result = await pembelianService.getDatatablesData(req.query);
    res.json({
      draw: parseInt(req.query.draw),
      recordsTotal: result.recordsTotal,
      recordsFiltered: result.recordsFiltered,
      data: result.data
    });
  } catch (err) {
    res.json({ error: err.message });
  }
};

exports.createForm = async function (req, res, next) {
  try {
    const supplierList = await supplierService.getAll();
    const kategoriList = await kategoriService.getAll();
    const barangList = []; // empty array for SSR
    res.render('pembelian/form', {
      title: 'Pembelian Baru',
      supplierList, barangList, kategoriList,
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
