const express           = require('express');
const router            = express.Router();
const devisController   = require('../controllers/devis.controller');
const { verifyToken }   = require('../middlewares/auth.middleware');
const { requireRole }   = require('../middlewares/rbac.middleware');

router.get('/',             verifyToken, devisController.getAll);
router.get('/:id',          verifyToken, devisController.getById);
router.post('/',            verifyToken, requireRole('commercial'), devisController.create);
router.put('/:id/statut',   verifyToken, requireRole('commercial', 'client'), devisController.updateStatut);
router.delete('/:id',       verifyToken, requireRole('admin', 'commercial'), devisController.remove);

module.exports = router;