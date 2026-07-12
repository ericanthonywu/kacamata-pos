const kasRepo = require('../repositories/kas.repository');
const laporanRepo = require('../repositories/laporan.repository');
const penjualanDetailRepo = require('../repositories/penjualan-detail.repository');
const penjualanRepo = require('../repositories/penjualan.repository');

exports.getKasReport = async function (filters) {
  const summary = await kasRepo.getSummary(filters);
  return {
    summary: {
      total_pembayaran: parseInt(summary.total_pembayaran) || 0,
      total_uang_masuk: parseFloat(summary.total_uang_masuk) || 0,
      total_cash: parseFloat(summary.total_cash) || 0,
      total_transfer: parseFloat(summary.total_transfer) || 0,
      uang_dari_penjualan: parseFloat(summary.uang_dari_penjualan) || 0,
      uang_dari_pelunasan: parseFloat(summary.uang_dari_pelunasan) || 0,
      total_bpjs: parseFloat(summary.total_bpjs) || 0,
      total_retur: parseFloat(summary.total_retur) || 0,
      total_retur_count: parseInt(summary.total_retur_count) || 0,
    },
  };
};

exports.getKasDatatablesData = function (params) {
  return kasRepo.getDatatablesData(params);
};

exports.getKasChartData = function (params) {
  return kasRepo.getChartData(params);
};

exports.getKomisiReport = async function (filters) {
  return laporanRepo.getKomisiReport(filters);
};

exports.getKomisiDetail = function (filters) {
  return laporanRepo.getKomisiDetail(filters);
};

/** Dashboard summary with date-scoped stats. */
exports.getDashboardSummary = function (today, firstOfMonth) {
  return kasRepo.getDashboardSummary(today, firstOfMonth);
};

exports.getTopBarang = function (from, to, limit) {
  return penjualanDetailRepo.getTopBarang(from, to, limit);
};

exports.getDailyTrend = function (from, to) {
  return penjualanRepo.getDailyTrend(from, to);
};

exports.getRecentPelanggan = function (limit) {
  return penjualanRepo.getRecentPelanggan(limit);
};

exports.getSalesPerformance = function (from, to) {
  return laporanRepo.getSalesPerformance(from, to);
};

exports.getKategoriBreakdown = function (from, to) {
  return laporanRepo.getKategoriBreakdown(from, to);
};

