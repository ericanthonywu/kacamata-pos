const service = require('../services/barang.service');
const kategoriService = require('../services/kategori.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const filters = { kategori_id: req.query.kategori_id };
    const kategoriList = await kategoriService.getAll();
    // Don't fetch all data here, DataTables will fetch via AJAX
    res.render('barang/index', { title: 'Barang', kategoriList, filters, activePage: 'barang' });
  } catch (err) { next(err); }
};

exports.search = async function (req, res) {
  try {
    const data = await service.search(req.query.q || '', req.query.kategori_nama);
    ok(res, data);
  } catch (err) { fail(res, err); }
};

exports.datatables = async function (req, res) {
  try {
    const result = await service.getDatatablesData(req.query);
    res.json({
      draw: parseInt(req.query.draw),
      recordsTotal: result.recordsTotal,
      recordsFiltered: result.recordsFiltered,
      totalQty: result.totalQty,
      outOfStock: result.outOfStock,
      data: result.data
    });
  } catch (err) {
    res.json({ error: err.message });
  }
};

exports.store = async function (req, res) {
  try {
    const result = await service.create(req.body);
    ok(res, result, 201);
  } catch (err) { fail(res, err); }
};

exports.update = async function (req, res) {
  try {
    const result = await service.update(req.params.id, req.body);
    ok(res, result);
  } catch (err) { fail(res, err); }
};

exports.destroy = async function (req, res) {
  try {
    await service.del(req.params.id);
    ok(res);
  } catch (err) { fail(res, err); }
};
