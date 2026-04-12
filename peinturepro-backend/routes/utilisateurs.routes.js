const express                 = require('express');
const router                  = express.Router();
const utilisateursController  = require('../controllers/utilisateurs.controller');
const { verifyToken }         = require('../middlewares/auth.middleware');
const { requireRole }         = require('../middlewares/rbac.middleware');

router.get('/',                       verifyToken, requireRole('admin'), utilisateursController.getAll);
router.get('/:id',                    verifyToken, requireRole('admin'), utilisateursController.getById);
router.put('/:id/actif',              verifyToken, requireRole('admin'), utilisateursController.toggleActif);
router.put('/:id/role',               verifyToken, requireRole('admin'), utilisateursController.changeRole);
router.put('/:id/reset-password',     verifyToken, requireRole('admin'), utilisateursController.resetPassword);
router.delete('/:id',                 verifyToken, requireRole('admin'), utilisateursController.remove);

module.exports = router;