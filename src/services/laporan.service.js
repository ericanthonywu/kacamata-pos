const repo = require('../repositories/laporan.repository');

exports.getKasReport = async function (filters) {
  const summary = await repo.getSummary(filters);
  return {
    summary: {
      total_pembayaran: parseInt(summary.total_pembayaran) || 0,
      total_uang_masuk: parseFloat(summary.total_uang_masuk) || 0,
      uang_dari_penjualan: parseFloat(summary.uang_dari_penjualan) || 0,
      uang_dari_pelunasan: parseFloat(summary.uang_dari_pelunasan) || 0,
      total_bpjs: parseFloat(summary.total_bpjs) || 0,
    },
  };
};

exports.getKasDatatablesData = function (params) {
  return repo.getKasDatatablesData(params);
};

exports.getKomisiReport = async function (filters) {
  return repo.getKomisiReport(filters);
};

exports.getKomisiDetail = function (filters) {
  return repo.getKomisiDetail(filters);
};
