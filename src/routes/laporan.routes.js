const router = require('express').Router();
const auth = require('../middleware/auth');
const c = require('../controllers/laporan.controller');
const { requireAdmin } = require('../middleware/rbac');

router.get('/kas', auth, c.kas);
router.get('/komisi', auth, requireAdmin, c.komisi);

module.exports = router;
