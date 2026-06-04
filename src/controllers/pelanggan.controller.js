const service = require('../services/pelanggan.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const data = await service.getAll();
    res.render('pelanggan/index', { title: 'Pelanggan', data, activePage: 'pelanggan' });
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
    const r = await service.create(req.body);
    ok(res, r, 201);
  } catch (err) { fail(res, err); }
};

exports.update = async function (req, res) {
  try {
    const r = await service.update(req.params.id, req.body);
    ok(res, r);
  } catch (err) { fail(res, err); }
};

exports.destroy = async function (req, res) {
  try {
    await service.del(req.params.id);
    ok(res);
  } catch (err) { fail(res, err); }
};
