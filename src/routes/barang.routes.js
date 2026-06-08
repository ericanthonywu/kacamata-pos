const router = require('express').Router();
const auth = require('../middleware/auth');
const c = require('../controllers/barang.controller');

const { requireAdmin } = require('../middleware/rbac');

router.get('/', auth, c.index);
router.get('/dt', auth, c.datatables);
router.get('/search', auth, c.search);
router.post('/', auth, requireAdmin, c.store);
router.put('/:id', auth, requireAdmin, c.update);
router.delete('/:id', auth, requireAdmin, c.destroy);

module.exports = router;
