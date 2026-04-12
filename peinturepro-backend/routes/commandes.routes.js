const express              = require('express');
const router               = express.Router();
const commandesController  = require('../controllers/commandes.controller');
const { verifyToken }      = require('../middlewares/auth.middleware');
const { requireRole }      = require('../middlewares/rbac.middleware');

router.get('/',             verifyToken, commandesController.getAll);
router.get('/:id',          verifyToken, commandesController.getById);
router.post('/',            verifyToken, requireRole('client'), commandesController.create);
router.put('/:id/statut',   verifyToken, requireRole('admin', 'commercial'), commandesController.updateStatut);
router.delete('/:id',       verifyToken, requireRole('admin'), commandesController.remove);

module.exports = router;