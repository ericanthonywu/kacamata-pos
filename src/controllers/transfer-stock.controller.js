const transferStockService = require('../services/transfer-stock.service');
const cabangService = require('../services/cabang.service');
const barangService = require('../services/barang.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const userCabangId = req.session.user.cabang_id;
    const allCabang = await cabangService.getAll();
    const targetCabangList = allCabang.filter(c => c.id !== userCabangId);
    const barangList = await barangService.getAll({}, userCabangId);

    res.render('transfer-stock/index', {
      title: 'Transfer Stock',
      activePage: 'transfer-stock',
      targetCabangList,
      barangList,
    });
  } catch (err) { next(err); }
};

exports.datatables = async function (req, res) {
  try {
    const userCabangId = req.session.user ? req.session.user.cabang_id : null;
    const result = await transferStockService.getDatatablesData(req.query, userCabangId);
    res.json({
      draw: parseInt(req.query.draw, 10),
      recordsTotal: result.recordsTotal,
      recordsFiltered: result.recordsFiltered,
      data: result.data,
    });
  } catch (err) {
    res.json({ error: err.message });
  }
};

exports.store = async function (req, res) {
  try {
    const result = await transferStockService.transfer(req.body, req.session.user);
    ok(res, result, 201);
  } catch (err) { fail(res, err); }
};
