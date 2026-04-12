const express            = require('express');
const router             = express.Router();
const produitsController = require('../controllers/produits.controller');
const { verifyToken }    = require('../middlewares/auth.middleware');
const { requireRole }    = require('../middlewares/rbac.middleware');

router.get('/',      verifyToken, produitsController.getAll);
router.get('/:id',   verifyToken, produitsController.getById);
router.post('/',     verifyToken, requireRole('admin'), produitsController.create);
router.put('/:id',   verifyToken, requireRole('admin'), produitsController.update);
router.delete('/:id',verifyToken, requireRole('admin'), produitsController.remove);

module.exports = router;