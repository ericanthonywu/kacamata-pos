const router = require('express').Router();
const auth = require('../middleware/auth');
const c = require('../controllers/pelanggan.controller');
const { requireAdmin } = require('../middleware/rbac');

router.get('/', auth, c.index);
router.get('/search', auth, c.search);
router.post('/', auth, c.store);
router.put('/:id', auth, c.update);
module.exports = router;
