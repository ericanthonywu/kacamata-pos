const kasRepo = require('../repositories/kas.repository');
const laporanRepo = require('../repositories/laporan.repository');

exports.getKasReport = async function (filters) {
  const summary = await kasRepo.getSummary(filters);
  const rawUangMasuk = parseFloat(summary.total_uang_masuk) || 0;
  const totalRetur = parseFloat(summary.total_retur) || 0;
  return {
    summary: {
      total_pembayaran: parseInt(summary.total_pembayaran) || 0,
      total_uang_masuk: rawUangMasuk - totalRetur,
      total_cash: parseFloat(summary.total_cash) || 0,
      total_transfer: parseFloat(summary.total_transfer) || 0,
      uang_dari_penjualan: parseFloat(summary.uang_dari_penjualan) || 0,
      uang_dari_pelunasan: parseFloat(summary.uang_dari_pelunasan) || 0,
      total_bpjs: parseFloat(summary.total_bpjs) || 0,
      total_retur: totalRetur,
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

/** Dashboard summary (lifetime). */
exports.getDashboardSummary = function () {
  return kasRepo.getSummary({});
};
