const service = require('../services/pembayaran-pembelian.service');
const pembelianService = require('../services/pembelian.service');
const { ok, fail } = require('../utils/response');

// Page 1: List of all unpaid pembelian
exports.index = async function (req, res, next) {
  try {
    const unpaid = await service.getUnpaid();
    res.render('pembayaran-pembelian/index', {
      title: 'Hutang Pembelian',
      unpaid,
      activePage: 'hutang-pembelian',
    });
  } catch (err) { next(err); }
};

// Page 2: Payment form + history for a specific pembelian
exports.bayarForm = async function (req, res, next) {
  try {
    const pembelian = await pembelianService.getById(req.params.id);
    if (!pembelian) { req.flash('error', 'Pembelian tidak ditemukan'); return res.redirect('/pembayaran-pembelian'); }
    const payments = await service.getByPembelianId(req.params.id);
    res.render('pembayaran-pembelian/form', {
      title: 'Bayar Hutang Pembelian',
      pembelian, payments,
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
