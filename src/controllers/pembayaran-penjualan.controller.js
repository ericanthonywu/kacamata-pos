const service = require('../services/pembayaran-penjualan.service');
const penjualanService = require('../services/penjualan.service');
const { ok, fail } = require('../utils/response');

// Page 1: List of all unpaid penjualan (DP/Belum Lunas)
exports.index = async function (req, res, next) {
  try {
    const unpaid = await service.getUnpaid(req.query);
    res.render('pembayaran-penjualan/index', {
      title: 'Hutang Penjualan (DP Pelanggan)',
      unpaid,
      query: req.query,
      activePage: 'hutang-penjualan',
    });
  } catch (err) { next(err); }
};

// Page 2: Payment form + history for a specific penjualan
exports.bayarForm = async function (req, res, next) {
  try {
    const penjualan = await penjualanService.getById(req.params.id);
    if (!penjualan) { req.flash('error', 'Penjualan tidak ditemukan'); return res.redirect('/pembayaran-penjualan'); }
    const payments = await service.getByPenjualanId(req.params.id);
    res.render('pembayaran-penjualan/form', {
      title: 'Pelunasan Hutang Penjualan',
      penjualan, payments,
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
