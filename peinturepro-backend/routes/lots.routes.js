const express          = require('express');
const router           = express.Router();
const lotsController   = require('../controllers/lots.controller');
const { verifyToken }  = require('../middlewares/auth.middleware');
const { requireRole }  = require('../middlewares/rbac.middleware');

// Lecture seule : admin ET commercial (tous les deux peuvent voir)
router.get('/',      verifyToken, requireRole('admin', 'commercial'), lotsController.getAll);
router.get('/:id',   verifyToken, requireRole('admin', 'commercial'), lotsController.getById);

// Écriture : uniquement le commercial (et pas l'admin)
router.post('/',     verifyToken, requireRole('commercial'), lotsController.create);
router.delete('/:id', verifyToken, requireRole('commercial'), lotsController.remove);

module.exports = router;