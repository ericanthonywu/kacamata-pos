/**
 * Shared komisi calculation logic.
 * Extracts the duplicated komisi_sales row-building that was previously
 * copy-pasted across penjualan, pembayaran-penjualan, and penjualan-retur repositories.
 */

/**
 * Calculate komisi rows for a given penjualan.
 *
 * @param {number} penjualanId
 * @param {object} sales       - The sales record (must have id, komisi_frame, komisi_lensa)
 * @param {Array}  detailItems - Rows from penjualan_detail
 * @returns {Array} Array of komisi_sales row objects ready for insert
 */
function buildKomisiRows(penjualanId, sales, detailItems) {
  let frameTotal = 0;
  let lensaTotal = 0;

  for (const line of detailItems) {
    const lineTotal = (parseFloat(line.harga || 0) - parseFloat(line.diskon || 0)) * parseInt(line.jumlah || 1);
    if (line.tipe === 'frame') {
      frameTotal += lineTotal;
    } else if (line.tipe === 'lensa_r' || line.tipe === 'lensa_l') {
      lensaTotal += lineTotal;
    }
  }

  const rows = [];

  if (frameTotal > 0 && parseFloat(sales.komisi_frame) > 0) {
    rows.push({
      penjualan_id: penjualanId,
      sales_id: sales.id,
      tipe: 'frame',
      persentase: sales.komisi_frame,
      nominal_komisi: frameTotal * parseFloat(sales.komisi_frame) / 100,
    });
  }

  if (lensaTotal > 0 && parseFloat(sales.komisi_lensa) > 0) {
    rows.push({
      penjualan_id: penjualanId,
      sales_id: sales.id,
      tipe: 'lensa',
      persentase: sales.komisi_lensa,
      nominal_komisi: lensaTotal * parseFloat(sales.komisi_lensa) / 100,
    });
  }

  return rows;
}

module.exports = { buildKomisiRows };
