const pool = require('../../config/db');

const CommandesQueries = {

  getAll: () =>
    pool.query(
      `SELECT c.*, u.nom AS client_nom
       FROM commandes c
       JOIN utilisateurs u ON c.client_id = u.id
       ORDER BY c.created_at DESC`
    ),

  getByClient: (clientId) =>
    pool.query(
      `SELECT c.*, u.nom AS client_nom
       FROM commandes c
       JOIN utilisateurs u ON c.client_id = u.id
       WHERE c.client_id = ?
       ORDER BY c.created_at DESC`,
      [clientId]
    ),

  getById: (id) =>
    pool.query(
      `SELECT c.*, u.nom AS client_nom
       FROM commandes c
       JOIN utilisateurs u ON c.client_id = u.id
       WHERE c.id = ?`,
      [id]
    ),

  getDetails: (commandeId) =>
    pool.query(
      `SELECT cd.*, p.nom AS produit_nom, p.couleur_code
       FROM commande_details cd
       JOIN produits p ON cd.produit_id = p.id
       WHERE cd.commande_id = ?`,
      [commandeId]
    ),

  create: (clientId, data) =>
    pool.query(
      `INSERT INTO commandes
       (client_id, surface_m2, litres_calcules, montant_total, statut, date_livraison_souhaitee)
       VALUES (?, ?, ?, ?, 'en_attente', ?)`,
      [clientId, data.surface_m2, data.litres_calcules, data.montant_total, data.date_livraison_souhaitee]
    ),

  addDetail: (commandeId, produitId, quantite, prix) =>
    pool.query(
      'INSERT INTO commande_details (commande_id, produit_id, quantite_litres, prix_litre) VALUES (?, ?, ?, ?)',
      [commandeId, produitId, quantite, prix]
    ),

  updateStatut: (id, statut) =>
    pool.query('UPDATE commandes SET statut = ? WHERE id = ?', [statut, id]),

  remove: (id) =>
    pool.query('DELETE FROM commandes WHERE id = ?', [id]),

  getCAMensuel: () =>
    pool.query(
      `SELECT MONTH(created_at) AS mois, YEAR(created_at) AS annee,
       SUM(montant_total) AS ca_total, COUNT(*) AS nb_commandes
       FROM commandes WHERE statut = 'livree'
       GROUP BY annee, mois ORDER BY annee DESC, mois DESC LIMIT 12`
    )
};

module.exports = CommandesQueries;