const service = require('../services/pembayaran-penjualan.service');
const penjualanService = require('../services/penjualan.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const unpaid = await service.getUnpaid();
    let selectedPenjualan = null;
    let payments = [];
    if (req.query.penjualan_id) {
      selectedPenjualan = await penjualanService.getById(req.query.penjualan_id);
      payments = await service.getByPenjualanId(req.query.penjualan_id);
    }
    res.render('pembayaran-penjualan/index', {
      title: 'Hutang Penjualan',
      unpaid, selectedPenjualan, payments,
      activePage: 'hutang-penjualan',
    });
  } catch (err) { next(err); }
};

exports.store = async function (req, res) {
  try {
    const result = await service.create(req.body);
    ok(res, result, 201);
  } catch (err) { fail(res, err); }
};

exports.destroy = async function (req, res) {
  try {
    await service.del(req.params.id);
    ok(res);
  } catch (err) { fail(res, err); }
};
