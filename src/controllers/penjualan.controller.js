const penjualanService = require('../services/penjualan.service');
const pelangganService = require('../services/pelanggan.service');
const salesService = require('../services/sales.service');
const barangService = require('../services/barang.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    res.render('penjualan/index', { title: 'Penjualan', activePage: 'penjualan' });
  } catch (err) { next(err); }
};

exports.datatables = async function (req, res) {
  try {
    const result = await penjualanService.getDatatablesData(req.query);
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

exports.pelunasanDpIndex = async function (req, res, next) {
  try {
    res.render('penjualan/pelunasan-dp', { title: 'Pelunasan DP', activePage: 'pelunasan_dp' });
  } catch (err) { next(err); }
};

exports.pelunasanDpDatatables = async function (req, res) {
  try {
    const result = await penjualanService.getPelunasanDpDatatables(req.query);
    res.json({
      draw: parseInt(req.query.draw),
      recordsTotal: result.recordsTotal,
      recordsFiltered: result.recordsFiltered,
      data: result.data,
      grandTotal: result.grandTotal
    });
  } catch (err) {
    res.json({ error: err.message });
  }
};

exports.tokoIndex = async function (req, res, next) {
  try {
    res.render('penjualan/toko-index', { title: 'Penjualan Toko (B2B)', activePage: 'penjualan-toko' });
  } catch (err) { next(err); }
};

exports.tokoDatatables = async function (req, res) {
  try {
    const query = { ...req.query, is_toko: 'true' };
    const result = await penjualanService.getDatatablesData(query);
    res.json({
      draw: parseInt(req.query.draw),
      recordsTotal: result.recordsTotal,
      recordsFiltered: result.recordsFiltered,
      data: result.data,
      totalPenjualanKhusus: result.totalPenjualanKhusus
    });
  } catch (err) {
    res.json({ error: err.message });
  }
};

exports.tokoCreateForm = async function (req, res, next) {
  try {
    const pelanggan = await pelangganService.getAll();
    const barangList = [];
    res.render('penjualan/toko-form', {
      title: 'Penjualan Toko Baru',
      pelanggan, barangList,
      activePage: 'penjualan-toko',
    });
  } catch (err) { next(err); }
};

exports.createForm = async function (req, res, next) {
  try {
    const [pelanggan, salesList] = await Promise.all([
      pelangganService.getAll(),
      salesService.getActive(),
    ]);
    const barangList = []; // empty array for SSR
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
