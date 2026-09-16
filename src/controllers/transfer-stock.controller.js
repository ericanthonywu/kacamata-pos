const transferStockService = require('../services/transfer-stock.service');
const barangService = require('../services/barang.service');
const { ok, fail } = require('../utils/response');

/**
 * Render Transfer Stock page in Cabang (incoming transfers list)
 */
exports.index = async function (req, res, next) {
  try {
    const incomingList = transferStockService.getIncomingTransfers();
    const barangList = await barangService.getAll();
    const pusatConfig = transferStockService.getPusatConfig();
    res.render('transfer-stock/index', {
      title: 'Transfer Stock',
      activePage: 'transfer-stock',
      incomingList: incomingList,
      barangList: barangList,
      pusatConfig: pusatConfig
    });
  } catch (err) {
    next(err);
  }
};

/**
 * API: Export items list for Pusat inter-app query
 * GET /api/stock-transfer/items
 */
exports.getApiItems = async function (req, res) {
  try {
    const items = await transferStockService.getExportItems();
    ok(res, { items });
  } catch (err) {
    fail(res, err);
  }
};

/**
 * API: Receive incoming stock transfer from Pusat
 * POST /api/stock-transfer/receive
 */
exports.receiveFromPusat = async function (req, res) {
  try {
    const result = await transferStockService.receiveTransfer(req.body);
    ok(res, result);
  } catch (err) {
    fail(res, err);
  }
};
