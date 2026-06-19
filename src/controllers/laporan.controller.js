const laporanService = require('../services/laporan.service');
const salesService = require('../services/sales.service');

const kategoriService = require('../services/kategori.service');

exports.kas = async function (req, res, next) {
  try {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const todayStr = `${year}-${month}-${String(now.getDate()).padStart(2, '0')}`;
    const firstDayOfMonth = `${year}-${month}-01`;

    const filters = {
      from: req.query.from || firstDayOfMonth,
      to: req.query.to || todayStr,
      sales_id: req.query.sales_id || null,
      kategori_id: req.query.kategori_id || null,
      status_bayar: req.query.status_bayar || null,
    };
    const [summary, salesList, kategoriList] = await Promise.all([
      laporanService.getKasReport(filters),
      salesService.getAll(),
      kategoriService.getAll(),
    ]);
    res.render('laporan/kas', {
      title: 'Laporan Kas',
      summary: summary.summary,
      salesList,
      kategoriList,
      filters,
      activePage: 'laporan-kas',
    });
  } catch (err) { next(err); }
};

exports.kasDatatables = async function (req, res) {
  try {
    const result = await laporanService.getKasDatatablesData(req.query);
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

exports.komisiDetail = async function (req, res, next) {
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

    const sales_id = req.params.sales_id;
    if (!sales_id) return res.redirect('/laporan/komisi');

    const filters = {
      from, to, bulan, tahun,
      sales_id: sales_id,
      tipe: req.query.tipe || 'frame',
    };

    const [details, sales] = await Promise.all([
      laporanService.getKomisiDetail(filters),
      salesService.getById(sales_id)
    ]);

    const grandTotal = details.reduce((s, r) => s + (parseFloat(r.nominal_komisi) || 0), 0);
    res.json({
      details, filters, grandTotal, sales
    });
  } catch (err) { res.status(500).json({ error: err.message }); }
};
