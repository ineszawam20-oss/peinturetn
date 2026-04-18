const express                 = require('express');
const router                  = express.Router();
const utilisateursController  = require('../controllers/utilisateurs.controller');
const { verifyToken }         = require('../middlewares/auth.middleware');
const { requireRole }         = require('../middlewares/rbac.middleware');

// ✅ NOUVELLE ROUTE — doit être AVANT /:id
router.get('/clients',                verifyToken, requireRole(['admin', 'commercial']), utilisateursController.getClients);

router.get('/',                       verifyToken, requireRole('admin'), utilisateursController.getAll);
router.get('/:id',                    verifyToken, requireRole('admin'), utilisateursController.getById);
router.put('/:id/actif',              verifyToken, requireRole('admin'), utilisateursController.toggleActif);
router.put('/:id/role',               verifyToken, requireRole('admin'), utilisateursController.changeRole);
router.put('/:id/reset-password',     verifyToken, requireRole('admin'), utilisateursController.resetPassword);
router.delete('/:id',                 verifyToken, requireRole('admin'), utilisateursController.remove);

module.exports = router;