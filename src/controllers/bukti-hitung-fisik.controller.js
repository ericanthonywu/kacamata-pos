const service = require('../services/bukti-hitung-fisik.service');
const { ok, fail } = require('../utils/response');
const { todayStr, firstDayOfMonth } = require('../utils/date.helper');

exports.index = async function (req, res, next) {
  try {
    const filters = {
      from: req.query.from || firstDayOfMonth(),
      to: req.query.to || todayStr(),
    };

    res.render('bukti-hitung-fisik/index', {
      title: 'Bukti Hitung Fisik',
      filters,
      activePage: 'bukti-hitung-fisik',
    });
  } catch (err) { next(err); }
};

exports.datatables = async function (req, res) {
  try {
    const result = await service.getDatatablesData(req.query);
    res.json({
      draw: parseInt(req.query.draw),
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
    const result = await service.createWithStockUpdate({
      barang_id: req.body.barang_id,
      qty_sesudah: req.body.qty_sesudah,
      diubah_oleh: req.session.user ? req.session.user.nama : '',
    });
    ok(res, result, 201);
  } catch (err) { fail(res, err); }
};

exports.storeBulk = async function (req, res) {
  try {
    const items = req.body.items;
    if (!items || !Array.isArray(items) || items.length === 0) {
      throw Object.assign(new Error('Minimal satu item harus diisi'), { status: 400 });
    }
    const result = await service.createBulkWithStockUpdate(
      items,
      req.session.user ? req.session.user.nama : ''
    );
    ok(res, result, 201);
  } catch (err) { fail(res, err); }
};

exports.destroy = async function (req, res) {
  try {
    await service.del(req.params.id);
    ok(res);
  } catch (err) { fail(res, err); }
};
