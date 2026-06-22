const router = require('express').Router();
const auth = require('../middleware/auth');
const { requireAdmin } = require('../middleware/rbac');
const c = require('../controllers/penjualan.controller');

router.get('/toko', auth, c.tokoIndex);
router.get('/toko/dt', auth, c.tokoDatatables);
router.get('/toko/baru', auth, c.tokoCreateForm);
router.get('/pelunasan-dp', auth, c.pelunasanDpIndex);
router.get('/pelunasan-dp/dt', auth, c.pelunasanDpDatatables);
router.get('/', auth, c.index);
router.get('/dt', auth, c.datatables);
router.get('/baru', auth, c.createForm);
router.post('/', auth, c.store);
router.get('/:id', auth, c.show);
router.put('/:id/metode-pembayaran', auth, c.updateMetodePembayaran);
router.delete('/:id', auth, requireAdmin, c.destroy);

module.exports = router;
