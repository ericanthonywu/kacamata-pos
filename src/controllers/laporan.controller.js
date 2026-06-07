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

exports.komisi = async function (req, res, next) {
  try {
    const today = new Date().toISOString().split('T')[0];
    const firstOfMonth = today.slice(0, 8) + '01';
    const filters = {
      from: req.query.from || firstOfMonth,
      to: req.query.to || today,
    };
    const data = await laporanService.getKomisiReport(filters);
    const grandTotal = data.reduce((s, r) => s + (parseFloat(r.total_komisi) || 0), 0);
    res.render('laporan/komisi', {
      title: 'Laporan Komisi Sales',
      data, filters, grandTotal,
      activePage: 'laporan-komisi',
    });
  } catch (err) { next(err); }
};
