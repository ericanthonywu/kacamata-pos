const router = require('express').Router();
const auth = require('../middleware/auth');
const c = require('../controllers/barang.controller');

router.get('/', auth, c.index);
router.get('/search', auth, c.search);
router.post('/', auth, c.store);
router.put('/:id', auth, c.update);
router.delete('/:id', auth, c.destroy);

module.exports = router;
