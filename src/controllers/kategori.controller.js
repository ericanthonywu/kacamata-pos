const service = require('../services/kategori.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const cabangId = req.session.user ? req.session.user.cabang_id : null;
    const data = await service.getAll(cabangId);
    res.render('kategori/index', { title: 'Kategori', data, activePage: 'kategori' });
  } catch (err) { next(err); }
};

exports.store = async function (req, res) {
  try {
    const userCabangId = req.session.user ? req.session.user.cabang_id : null;
    const result = await service.create(req.body, userCabangId);
    ok(res, result, 201);
  } catch (err) { fail(res, err); }
};

exports.update = async function (req, res) {
  try {
    const result = await service.update(req.params.id, req.body);
    ok(res, result);
  } catch (err) { fail(res, err); }
};
