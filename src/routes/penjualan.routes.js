const router = require('express').Router();
const auth = require('../middleware/auth');
const { requireAdmin } = require('../middleware/rbac');
const c = require('../controllers/penjualan.controller');

router.get('/', auth, c.index);
router.get('/dt', auth, c.datatables);
router.get('/baru', auth, c.createForm);
router.post('/', auth, c.store);
router.get('/:id', auth, c.show);
router.delete('/:id', auth, requireAdmin, c.destroy);

module.exports = router;
