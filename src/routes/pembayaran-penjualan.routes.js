const router = require('express').Router();
const auth = require('../middleware/auth');
const c = require('../controllers/pembayaran-penjualan.controller');

const { requireAdmin } = require('../middleware/rbac');

router.get('/', auth, c.index);
router.get('/bayar/:id', auth, c.bayarForm);
router.post('/', auth, c.store);
router.delete('/:id', requireAdmin, c.destroy);

module.exports = router;
