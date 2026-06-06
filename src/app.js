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
app.get('/', auth, (req, res) => {
  res.render('dashboard', { title: 'Dashboard', activePage: 'dashboard' });
});

// Stock Gudang (read-only, reuses barang data)
const barangService = require('./services/barang.service');
app.get('/stock-gudang', auth, async (req, res, next) => {
  try {
    const data = await barangService.getAll();
    res.render('stock-gudang/index', { title: 'Stock Gudang', data, activePage: 'stock-gudang' });
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
app.use('/laporan', require('./routes/laporan.routes'));

// Error handler
app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`\n🚀 Kacamata POS running on http://localhost:${PORT}`);
  console.log(`   Login: admin / admin123\n`);
});
