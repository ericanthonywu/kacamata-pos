const router = require('express').Router();
const auth = require('../middleware/auth');
const c = require('../controllers/kategori.controller');

router.get('/', auth, c.index);
router.post('/', auth, c.store);
router.put('/:id', auth, c.update);

module.exports = router;
