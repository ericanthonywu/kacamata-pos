const router = require('express').Router();
const auth = require('../middleware/auth');
const c = require('../controllers/pembelian-retur.controller');

router.get('/', auth, c.index);
router.get('/baru', auth, c.createForm);
router.post('/', auth, c.store);
router.get('/pembelian/:id', auth, c.getPembelianDetail);
router.get('/:id', auth, c.show);
router.delete('/:id', auth, c.destroy);

module.exports = router;
