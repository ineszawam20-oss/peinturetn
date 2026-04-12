const pool = require('../config/db');

async function getAll(req, res, next) {
  try {
    let query  = `SELECT d.*, u.nom AS client_nom FROM devis d
                  JOIN utilisateurs u ON d.client_id = u.id`;
    const params = [];
    if (req.user.role === 'client') {
      query += ' WHERE d.client_id = ?';
      params.push(req.user.id);
    }
    query += ' ORDER BY d.created_at DESC';
    const [rows] = await pool.query(query, params);
    res.json(rows);
  } catch (err) { next(err); }
}

async function getById(req, res, next) {
  try {
    const [rows] = await pool.query('SELECT * FROM devis WHERE id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ message: 'Devis introuvable.' });
    res.json(rows[0]);
  } catch (err) { next(err); }
}

async function create(req, res, next) {
  try {
    const { client_id, surface_m2, produit_id, prix_litre, litres_calcules } = req.body;
    const montant_total = prix_litre * litres_calcules;

    const [result] = await pool.query(
      `INSERT INTO devis (client_id, surface_m2, montant_total, statut, expires_at)
       VALUES (?, ?, ?, 'brouillon', DATE_ADD(NOW(), INTERVAL 30 DAY))`,
      [client_id, surface_m2, montant_total]
    );
    res.status(201).json({ message: 'Devis créé.', id: result.insertId, montant_total });
  } catch (err) { next(err); }
}

async function updateStatut(req, res, next) {
  try {
    const { statut } = req.body;
    const validStatuts = ['brouillon', 'envoye', 'accepte', 'refuse', 'expire'];
    if (!validStatuts.includes(statut))
      return res.status(400).json({ message: 'Statut invalide.' });

    await pool.query('UPDATE devis SET statut = ? WHERE id = ?', [statut, req.params.id]);
    res.json({ message: 'Statut devis mis à jour.' });
  } catch (err) { next(err); }
}

async function remove(req, res, next) {
  try {
    await pool.query('DELETE FROM devis WHERE id = ?', [req.params.id]);
    res.json({ message: 'Devis supprimé.' });
  } catch (err) { next(err); }
}

module.exports = { getAll, getById, create, updateStatut, remove };