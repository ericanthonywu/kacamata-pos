const repo = require('../repositories/laporan.repository');

exports.getKasReport = async function (filters) {
  const [summary, transactions] = await Promise.all([
    repo.getSummary(filters),
    repo.getKasReport(filters),
  ]);
  return {
    summary: {
      total_transaksi: parseInt(summary.total_transaksi) || 0,
      total_subtotal: parseFloat(summary.total_subtotal) || 0,
      total_pelunasan: parseFloat(summary.total_pelunasan) || 0,
      total_bpjs: parseFloat(summary.total_bpjs) || 0,
      total_penjualan: parseFloat(summary.total_penjualan) || 0,
    },
    transactions,
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
