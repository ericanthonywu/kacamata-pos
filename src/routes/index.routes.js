const express = require('express');
const router = express.Router();
const path = require('path');
const fs = require('fs');
const os = require('os');
const { exec } = require('child_process');

const auth = require('../middleware/auth');
const { requireAdmin } = require('../middleware/rbac');

const pembayaranPembelianService = require('../services/pembayaran-pembelian.service');
const pembayaranPenjualanService = require('../services/pembayaran-penjualan.service');
const laporanRepo = require('../repositories/laporan.repository');
const kategoriService = require('../services/kategori.service');

// Auth routes
router.use('/', require('./auth.routes'));

// Dashboard
router.get('/', auth, async (req, res, next) => {
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
router.get('/stock-gudang', auth, async (req, res, next) => {
  try {
    const kategoriList = await kategoriService.getAll();
    res.render('stock-gudang/index', { title: 'Stock Gudang', kategoriList, activePage: 'stock-gudang' });
  } catch (err) { next(err); }
});

// Application Routes
router.use('/kategori', requireAdmin, require('./kategori.routes'));
router.use('/metode-pembayaran', auth, require('./metode-pembayaran.routes'));
router.use('/barang', require('./barang.routes')); 
router.use('/supplier', requireAdmin, require('./supplier.routes'));
router.use('/pelanggan', require('./pelanggan.routes')); 
router.use('/sales', requireAdmin, require('./sales.routes'));
router.use('/pengguna', requireAdmin, require('./pengguna.routes'));
router.use('/penjualan', require('./penjualan.routes')); 
router.use('/pembelian', require('./pembelian.routes')); 
router.use('/pembelian-retur', requireAdmin, require('./pembelian-retur.routes'));
router.use('/penjualan-retur', requireAdmin, require('./penjualan-retur.routes'));
router.use('/pembayaran-pembelian', requireAdmin, require('./pembayaran-pembelian.routes'));
router.use('/pembayaran-penjualan', require('./pembayaran-penjualan.routes'));
router.use('/laporan', require('./laporan.routes')); 

// Print API
router.post('/api/print/raw', auth, (req, res) => {
  const { textData, printerName } = req.body;
  if (!textData || !printerName) {
    return res.status(400).json({ success: false, message: 'Data teks dan nama printer harus diisi' });
  }
  console.log("text data", textData)
  const tempFile = path.join(os.tmpdir(), 'nota_temp.txt');
  fs.writeFileSync(tempFile, textData, 'utf8');

  // Build print command. We use standard Windows UNC path: \\COMPUTERNAME\SharedPrinterName
  const host = os.hostname();
  const printCommand = `copy /b "${tempFile}" "\\\\${host}\\${printerName}"`;

  exec(printCommand, (error, stdout, stderr) => {
    if (error) {
      console.error('Print Error:', error);
      return res.status(500).json({ success: false, message: 'Gagal nge-print. Pastikan printer sudah di-share dengan nama: ' + printerName });
    }
    res.json({ success: true, message: 'Berhasil dikirim ke printer' });
  });
});

module.exports = router;
