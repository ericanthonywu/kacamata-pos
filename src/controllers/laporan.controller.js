const laporanService = require('../services/laporan.service');
const salesService = require('../services/sales.service');

exports.kas = async function (req, res, next) {
  try {
    const filters = {
      from: req.query.from || new Date().toISOString().split('T')[0],
      to: req.query.to || new Date().toISOString().split('T')[0],
      sales_id: req.query.sales_id || null,
    };
    const [report, salesList] = await Promise.all([
      laporanService.getKasReport(filters),
      salesService.getAll(),
    ]);
    res.render('laporan/kas', {
      title: 'Laporan Kas',
      ...report,
      salesList,
      filters,
      activePage: 'laporan-kas',
    });
  } catch (err) { next(err); }
};
