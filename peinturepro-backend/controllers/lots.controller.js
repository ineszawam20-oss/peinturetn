const pool = require('../config/db');

async function getAll(req, res, next) {
  try {
    const [rows] = await pool.query(
      `SELECT l.*, p.nom AS produit_nom FROM lots_production l
       JOIN produits p ON l.produit_id = p.id
       ORDER BY l.created_at DESC`
    );
    res.json(rows);
  } catch (err) { next(err); }
}

async function getById(req, res, next) {
  try {
    const [rows] = await pool.query(
      'SELECT * FROM lots_production WHERE id = ?', [req.params.id]
    );
    if (!rows.length) return res.status(404).json({ message: 'Lot introuvable.' });
    res.json(rows[0]);
  } catch (err) { next(err); }
}

async function create(req, res, next) {
  try {
    const { produit_id, quantite_litres, date_expiration } = req.body;

    // Générer numéro lot automatique : PEINT-AAAAMMJJ-NNN
    const today    = new Date();
    const datePart = today.toISOString().slice(0,10).replace(/-/g,'');
    const [count]  = await pool.query(
      'SELECT COUNT(*) AS total FROM lots_production WHERE DATE(created_at) = CURDATE()'
    );
    const num      = String(count[0].total + 1).padStart(3, '0');
    const numero   = `PEINT-${datePart}-${num}`;

    const [result] = await pool.query(
      'INSERT INTO lots_production (produit_id, quantite_litres, numero_lot, date_expiration) VALUES (?, ?, ?, ?)',
      [produit_id, quantite_litres, numero, date_expiration]
    );

    // Mettre à jour le stock du produit
    await pool.query(
      'UPDATE produits SET stock_litres = stock_litres + ? WHERE id = ?',
      [quantite_litres, produit_id]
    );

    res.status(201).json({ message: 'Lot créé.', id: result.insertId, numero_lot: numero });
  } catch (err) { next(err); }
}

async function remove(req, res, next) {
  try {
    await pool.query('DELETE FROM lots_production WHERE id = ?', [req.params.id]);
    res.json({ message: 'Lot supprimé.' });
  } catch (err) { next(err); }
}

module.exports = { getAll, getById, create, remove };