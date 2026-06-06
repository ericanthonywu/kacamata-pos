const router = require('express').Router();
const auth = require('../middleware/auth');
const c = require('../controllers/penjualan-retur.controller');

router.get('/', auth, c.index);
router.get('/baru', auth, c.createForm);
router.post('/', auth, c.store);
router.get('/penjualan/:id', auth, c.getPenjualanDetail);
router.get('/:id', auth, c.show);
router.delete('/:id', auth, c.destroy);

module.exports = router;
