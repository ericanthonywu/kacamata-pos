const router = require('express').Router();
const auth = require('../middleware/auth');
const c = require('../controllers/pembelian.controller');

const { requireAdmin } = require('../middleware/rbac');

router.get('/', auth, c.index);
router.get('/dt', auth, c.datatables);
router.get('/baru', auth, requireAdmin, c.createForm);
router.post('/', auth, requireAdmin, c.store);
router.get('/:id', auth, c.show);
router.delete('/:id', auth, requireAdmin, c.destroy);

module.exports = router;
