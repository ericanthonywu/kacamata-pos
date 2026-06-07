require('dotenv').config();
const express = require('express');
const path = require('path');
const flash = require('connect-flash');
const sessionMiddleware = require('./config/session');
const errorHandler = require('./middleware/errorHandler');
const auth = require('./middleware/auth');

const app = express();
const PORT = process.env.PORT || 3000;

// View engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '..', 'views'));

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, '..', 'public')));
app.use(sessionMiddleware);
app.use(flash());

// Global template vars
app.use((req, res, next) => {
  res.locals.currentUser = req.session.user || null;
  res.locals.success = req.flash('success')[0] || null;
  res.locals.error = req.flash('error')[0] || null;
  next();
});

// Routes
app.use('/', require('./routes/auth.routes'));

// Dashboard
const pembayaranPembelianService = require('./services/pembayaran-pembelian.service');
const pembayaranPenjualanService = require('./services/pembayaran-penjualan.service');
const laporanRepo = require('./repositories/laporan.repository');
app.get('/', auth, async (req, res, next) => {
  try {
    const hutangPembelian = await pembayaranPembelianService.getUnpaid();
    const hutangPenjualan = await pembayaranPenjualanService.getUnpaid();
    const totalHutangPembelian = hutangPembelian.reduce((s, p) => s + (parseFloat(p.total_harga) - parseFloat(p.total_dibayar)), 0);
    const totalHutangPenjualan = hutangPenjualan.reduce((s, p) => s + (parseFloat(p.total) - parseFloat(p.total_dibayar)), 0);
    const lifetimeSummary = await laporanRepo.getSummary({});
    res.render('dashboard', {
      title: 'Dashboard', activePage: 'dashboard',
      hutangPembelian, hutangPenjualan,
      totalHutangPembelian, totalHutangPenjualan,
      lifetimeSummary,
    });
  } catch (err) { next(err); }
});

// Stock Gudang (read-only, reuses barang data)
const barangService = require('./services/barang.service');
const kategoriService = require('./services/kategori.service');
app.get('/stock-gudang', auth, async (req, res, next) => {
  try {
    const kategoriList = await kategoriService.getAll();
    res.render('stock-gudang/index', { title: 'Stock Gudang', kategoriList, activePage: 'stock-gudang' });
  } catch (err) { next(err); }
});

app.use('/kategori', require('./routes/kategori.routes'));
app.use('/barang', require('./routes/barang.routes'));
app.use('/supplier', require('./routes/supplier.routes'));
app.use('/pelanggan', require('./routes/pelanggan.routes'));
app.use('/sales', require('./routes/sales.routes'));
app.use('/pengguna', require('./routes/pengguna.routes'));
app.use('/penjualan', require('./routes/penjualan.routes'));
app.use('/pembelian', require('./routes/pembelian.routes'));
app.use('/pembelian-retur', require('./routes/pembelian-retur.routes'));
app.use('/penjualan-retur', require('./routes/penjualan-retur.routes'));
app.use('/pembayaran-pembelian', require('./routes/pembayaran-pembelian.routes'));
app.use('/pembayaran-penjualan', require('./routes/pembayaran-penjualan.routes'));
app.use('/laporan', require('./routes/laporan.routes'));

// Error handler
app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`\n🚀 OPTIK SENTRAL running on http://localhost:${PORT}`);
  console.log(`   Login: admin / admin123\n`);
});
