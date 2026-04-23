const pool = require('../../config/db');

const ProduitsQueries = {

  getAll: () =>
    pool.query('SELECT * FROM produits ORDER BY nom'),

  getById: (id) =>
    pool.query('SELECT * FROM produits WHERE id = ?', [id]),

  create: (data) =>
    pool.query(
      `INSERT INTO produits
       (nom, type, finition, couleur_code, rendement_m2_L, prix_litre, stock_litres, stock_minimum, image, description)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [data.nom, data.type, data.finition, data.couleur_code,
       data.rendement_m2_L || 10, data.prix_litre,
       data.stock_litres || 0, data.stock_minimum || 50,
       data.image || null, data.description || null]
    ),

  update: (id, data) =>
    pool.query(
      `UPDATE produits SET nom=?, type=?, finition=?, couleur_code=?,
       rendement_m2_L=?, prix_litre=?, stock_litres=?, stock_minimum=?,
       image=?, description=?
       WHERE id=?`,
      [data.nom, data.type, data.finition, data.couleur_code,
       data.rendement_m2_L, data.prix_litre,
       data.stock_litres, data.stock_minimum,
       data.image || null, data.description || null, id]
    ),

  remove: (id) =>
    pool.query('DELETE FROM produits WHERE id = ?', [id]),

  getLowStock: () =>
    pool.query('SELECT * FROM produits WHERE stock_litres <= stock_minimum'),

  updateStock: (id, quantite) =>
    pool.query('UPDATE produits SET stock_litres = stock_litres + ? WHERE id = ?', [quantite, id])
};

module.exports = ProduitsQueries;