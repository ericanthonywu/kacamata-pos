const router = require('express').Router();
const auth = require('../middleware/auth');
const c = require('../controllers/laporan.controller');

router.get('/kas', auth, c.kas);

module.exports = router;
