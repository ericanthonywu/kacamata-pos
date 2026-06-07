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
    const today = new Date();
    const currentMonth = today.getMonth() + 1;
    const currentYear = today.getFullYear();
    const bulan = req.query.bulan ? parseInt(req.query.bulan) : currentMonth;
    const tahun = req.query.tahun ? parseInt(req.query.tahun) : currentYear;
    
    // Calculate first and last day of the month
    const from = `${tahun}-${bulan.toString().padStart(2, '0')}-01`;
    const lastDay = new Date(tahun, bulan, 0).getDate();
    const to = `${tahun}-${bulan.toString().padStart(2, '0')}-${lastDay}`;

    const filters = {
      from, to, bulan, tahun,
      sales_id: req.query.sales_id || null,
      tipe: req.query.tipe || 'frame',
    };

    const [data, salesList] = await Promise.all([
      laporanService.getKomisiReport(filters),
      salesService.getAll()
    ]);

    const grandTotal = data.reduce((s, r) => s + (parseFloat(r.total_komisi) || 0), 0);
    res.render('laporan/komisi', {
      title: 'Laporan Komisi Sales',
      data, filters, grandTotal, salesList,
      activePage: 'laporan-komisi',
    });
  } catch (err) { next(err); }
};
