const express             = require('express');
const router              = express.Router();
const { verifyToken }     = require('../middlewares/auth.middleware');
const { requireRole }     = require('../middlewares/rbac.middleware');
const pool                = require('../config/db');

router.get('/', verifyToken, async (req, res, next) => {
  try {
    const [rows] = await pool.query('SELECT * FROM chantiers ORDER BY created_at DESC');
    res.json(rows);
  } catch (err) { next(err); }
});

router.get('/:id', verifyToken, async (req, res, next) => {
  try {
    const [rows] = await pool.query('SELECT * FROM chantiers WHERE id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ message: 'Chantier introuvable.' });
    res.json(rows[0]);
  } catch (err) { next(err); }
});

router.post('/', verifyToken, requireRole('client'), async (req, res, next) => {
  try {
    const { adresse, ville, gouvernorat } = req.body;

    if (!adresse || !ville || !gouvernorat) {
      return res.status(400).json({ message: 'Champs manquants.' });
    }
       const client_id = req.user.id; // ← récupéré depuis le token JWT
    const [result] = await pool.query(
      `INSERT INTO chantiers (adresse, ville, gouvernorat, client_id, created_at)
       VALUES (?, ?, ?, ?, NOW())`,
      [adresse, ville, gouvernorat, client_id]
    );

    res.status(201).json({ id: result.insertId });

  } catch (err) {
    next(err);
  }
});

module.exports = router;