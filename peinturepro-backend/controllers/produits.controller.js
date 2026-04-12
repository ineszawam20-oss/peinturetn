const pool = require('../config/db');

async function getAll(req, res, next) {
  try {
    const [rows] = await pool.query('SELECT * FROM produits ORDER BY nom');
    res.json(rows);
  } catch (err) { next(err); }
}

async function getById(req, res, next) {
  try {
    const [rows] = await pool.query('SELECT * FROM produits WHERE id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ message: 'Produit introuvable.' });
    res.json(rows[0]);
  } catch (err) { next(err); }
}

async function create(req, res, next) {
  try {
    const { nom, type, finition, couleur_code, rendement_m2_L, prix_litre, stock_litres, stock_minimum } = req.body;
    if (!nom || !prix_litre)
      return res.status(400).json({ message: 'Nom et prix requis.' });

    const [result] = await pool.query(
      `INSERT INTO produits (nom, type, finition, couleur_code, rendement_m2_L, prix_litre, stock_litres, stock_minimum)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [nom, type, finition, couleur_code, rendement_m2_L || 10, prix_litre, stock_litres || 0, stock_minimum || 50]
    );
    res.status(201).json({ message: 'Produit créé.', id: result.insertId });
  } catch (err) { next(err); }
}

async function update(req, res, next) {
  try {
    const { nom, type, finition, couleur_code, rendement_m2_L, prix_litre, stock_litres, stock_minimum } = req.body;
    await pool.query(
      `UPDATE produits SET nom=?, type=?, finition=?, couleur_code=?, rendement_m2_L=?,
       prix_litre=?, stock_litres=?, stock_minimum=? WHERE id=?`,
      [nom, type, finition, couleur_code, rendement_m2_L, prix_litre, stock_litres, stock_minimum, req.params.id]
    );
    res.json({ message: 'Produit mis à jour.' });
  } catch (err) { next(err); }
}

async function remove(req, res, next) {
  try {
    await pool.query('DELETE FROM produits WHERE id = ?', [req.params.id]);
    res.json({ message: 'Produit supprimé.' });
  } catch (err) { next(err); }
}

module.exports = { getAll, getById, create, update, remove };