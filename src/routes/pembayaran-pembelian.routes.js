const router = require('express').Router();
const auth = require('../middleware/auth');
const c = require('../controllers/pembayaran-pembelian.controller');

router.get('/', auth, c.index);
router.get('/bayar/:id', auth, c.bayarForm);
router.post('/', auth, c.store);
router.delete('/:id', auth, c.destroy);

module.exports = router;
