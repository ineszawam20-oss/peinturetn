const express = require('express');
const router = express.Router();
const matieresController = require('../controllers/matieres-premieres.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { requireRole } = require('../middlewares/rbac.middleware');

// ⚠️ Lecture : autoriser admin ET commercial
router.get('/', verifyToken, requireRole('admin', 'commercial'), matieresController.getAll);
router.get('/:id', verifyToken, requireRole('admin', 'commercial'), matieresController.getById);

// Écriture : seulement commercial
router.post('/', verifyToken, requireRole('commercial'), matieresController.create);
router.put('/:id', verifyToken, requireRole('commercial'), matieresController.update);
router.delete('/:id', verifyToken, requireRole('commercial'), matieresController.remove);

module.exports = router;