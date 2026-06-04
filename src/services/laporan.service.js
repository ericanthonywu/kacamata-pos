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
      total_biaya: parseFloat(summary.total_biaya) || 0,
      total_penjualan: parseFloat(summary.total_penjualan) || 0,
    },
    transactions,
  };
};
