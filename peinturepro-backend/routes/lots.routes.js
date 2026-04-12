const express          = require('express');
const router           = express.Router();
const lotsController   = require('../controllers/lots.controller');
const { verifyToken }  = require('../middlewares/auth.middleware');
const { requireRole }  = require('../middlewares/rbac.middleware');

router.get('/',      verifyToken, requireRole('admin'), lotsController.getAll);
router.get('/:id',   verifyToken, requireRole('admin'), lotsController.getById);
router.post('/',     verifyToken, requireRole('admin'), lotsController.create);
router.delete('/:id',verifyToken, requireRole('admin'), lotsController.remove);

module.exports = router;