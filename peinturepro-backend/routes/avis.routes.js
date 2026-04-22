const express = require('express');
const router = express.Router();
const avisController = require('../controllers/avis.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { requireRole } = require('../middlewares/rbac.middleware');

// GET /api/avis - tous les avis (public)
router.get('/', avisController.getAll);

// POST /api/avis - créer un avis (client uniquement)
router.post('/', verifyToken, requireRole('client'), avisController.create);

// DELETE /api/avis/:id - admin peut supprimer
router.delete('/:id', verifyToken, requireRole('admin'), avisController.remove);

module.exports = router;