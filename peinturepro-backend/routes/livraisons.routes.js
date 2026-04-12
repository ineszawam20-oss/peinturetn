const express               = require('express');
const router                = express.Router();
const livraisonsController  = require('../controllers/livraisons.controller');
const { verifyToken }       = require('../middlewares/auth.middleware');
const { requireRole }       = require('../middlewares/rbac.middleware');

router.get('/',             verifyToken, livraisonsController.getAll);
router.get('/:id',          verifyToken, livraisonsController.getById);
router.put('/:id/statut',   verifyToken, requireRole('livreur', 'admin'), livraisonsController.updateStatut);

module.exports = router;