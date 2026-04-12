const bcrypt = require('bcryptjs');
const pool   = require('../config/db');

async function getAll(req, res, next) {
  try {
    const [rows] = await pool.query(
      'SELECT id, nom, email, role, telephone, adresse, actif, created_at FROM utilisateurs ORDER BY created_at DESC'
    );
    res.json(rows);
  } catch (err) { next(err); }
}

async function getById(req, res, next) {
  try {
    const [rows] = await pool.query(
      'SELECT id, nom, email, role, telephone, adresse, actif FROM utilisateurs WHERE id = ?',
      [req.params.id]
    );
    if (!rows.length) return res.status(404).json({ message: 'Utilisateur introuvable.' });
    res.json(rows[0]);
  } catch (err) { next(err); }
}

async function toggleActif(req, res, next) {
  try {
    const { actif } = req.body;
    await pool.query('UPDATE utilisateurs SET actif = ? WHERE id = ?', [actif ? 1 : 0, req.params.id]);
    res.json({ message: `Compte ${actif ? 'activé' : 'désactivé'}.` });
  } catch (err) { next(err); }
}

async function changeRole(req, res, next) {
  try {
    const { role } = req.body;
    const validRoles = ['admin', 'commercial', 'livreur', 'client'];
    if (!validRoles.includes(role))
      return res.status(400).json({ message: 'Rôle invalide.' });

    await pool.query('UPDATE utilisateurs SET role = ? WHERE id = ?', [role, req.params.id]);
    res.json({ message: 'Rôle mis à jour.' });
  } catch (err) { next(err); }
}

async function resetPassword(req, res, next) {
  try {
    const tempPassword = Math.random().toString(36).slice(-8) + 'A1!';
    const hash         = await bcrypt.hash(tempPassword, 12);
    await pool.query('UPDATE utilisateurs SET password = ? WHERE id = ?', [hash, req.params.id]);
    // TODO: envoyer tempPassword par email
    res.json({ message: 'Mot de passe réinitialisé.', tempPassword });
  } catch (err) { next(err); }
}

async function remove(req, res, next) {
  try {
    await pool.query('UPDATE utilisateurs SET actif = 0 WHERE id = ?', [req.params.id]);
    res.json({ message: 'Compte désactivé (soft delete).' });
  } catch (err) { next(err); }
}

module.exports = { getAll, getById, toggleActif, changeRole, resetPassword, remove };