const router = require('express').Router();
const auth = require('../middleware/auth');
const { requireAdmin } = require('../middleware/rbac');
const c = require('../controllers/bukti-hitung-fisik.controller');

router.get('/', auth, c.index);
router.get('/dt', auth, c.datatables);
router.post('/', auth, c.store);
router.delete('/:id', auth, requireAdmin, c.destroy);

module.exports = router;
