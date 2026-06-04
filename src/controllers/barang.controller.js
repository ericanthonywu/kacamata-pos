const service = require('../services/barang.service');
const kategoriService = require('../services/kategori.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const [data, kategoriList] = await Promise.all([service.getAll(), kategoriService.getAll()]);
    res.render('barang/index', { title: 'Barang', data, kategoriList, activePage: 'barang' });
  } catch (err) { next(err); }
};

exports.search = async function (req, res) {
  try {
    const data = await service.search(req.query.q || '');
    ok(res, data);
  } catch (err) { fail(res, err); }
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
