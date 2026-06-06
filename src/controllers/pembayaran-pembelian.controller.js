const service = require('../services/pembayaran-pembelian.service');
const pembelianService = require('../services/pembelian.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const unpaid = await service.getUnpaid();

    // If specific pembelian_id is provided, show payment history
    let selectedPembelian = null;
    let payments = [];
    if (req.query.pembelian_id) {
      selectedPembelian = await pembelianService.getById(req.query.pembelian_id);
      payments = await service.getByPembelianId(req.query.pembelian_id);
    }

    res.render('pembayaran-pembelian/index', {
      title: 'Hutang Pembelian',
      unpaid, selectedPembelian, payments,
      activePage: 'hutang-pembelian',
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
