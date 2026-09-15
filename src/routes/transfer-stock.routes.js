const express = require('express');
const router = express.Router();
const controller = require('../controllers/transfer-stock.controller');

router.get('/', controller.index);
router.get('/dt', controller.datatables);
router.post('/', controller.store);

module.exports = router;
