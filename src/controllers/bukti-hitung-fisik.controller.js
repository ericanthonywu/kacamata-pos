const service = require('../services/bukti-hitung-fisik.service');
const { ok, fail } = require('../utils/response');

exports.index = async function (req, res, next) {
  try {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const todayStr = `${year}-${month}-${String(now.getDate()).padStart(2, '0')}`;
    const firstDayOfMonth = `${year}-${month}-01`;

    const filters = {
      from: req.query.from || firstDayOfMonth,
      to: req.query.to || todayStr,
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

exports.destroy = async function (req, res) {
  try {
    await service.del(req.params.id);
    ok(res);
  } catch (err) { fail(res, err); }
};
