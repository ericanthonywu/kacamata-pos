const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const c = require('../controllers/transfer-stock.controller');

router.get('/', auth, c.index);

module.exports = router;
