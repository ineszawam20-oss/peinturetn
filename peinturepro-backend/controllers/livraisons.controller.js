const pool = require('../config/db');

async function getAll(req, res, next) {
  try {
    let query = `SELECT l.*, c.adresse AS chantier_adresse, c.ville,
                 c.latitude AS chantier_latitude, c.longitude AS chantier_longitude,
                 co.montant_total, u.nom AS client_nom
                 FROM livraisons l
                 LEFT JOIN chantiers c  ON l.chantier_id  = c.id
                 LEFT JOIN commandes co ON l.commande_id  = co.id
                 LEFT JOIN utilisateurs u ON co.client_id = u.id`;
    const params = [];

    if (req.user.role === 'livreur') {
      // Voir les planifiées (non assignées) ET ses propres livraisons en cours/livrées
      query += ' WHERE (l.livreur_id IS NULL OR l.livreur_id = ?)';
      params.push(req.user.id);
    }

    query += ' ORDER BY l.created_at DESC';
    const [rows] = await pool.query(query, params);
    res.json(rows);
  } catch (err) { next(err); }
}

async function getById(req, res, next) {
  try {
    const [rows] = await pool.query(
      `SELECT l.*, c.adresse, c.ville, c.latitude, c.longitude
       FROM livraisons l
       LEFT JOIN chantiers c ON l.chantier_id = c.id
       WHERE l.id = ?`,
      [req.params.id]
    );
    if (!rows.length) return res.status(404).json({ message: 'Livraison introuvable.' });
    res.json(rows[0]);
  } catch (err) { next(err); }
}
async function updateStatut(req, res, next) {
  try {
    const { statut, notes } = req.body;
    const validStatuts = ['planifiee', 'en_cours', 'livree'];
    if (!validStatuts.includes(statut))
      return res.status(400).json({ message: 'Statut invalide.' });

    // On assigne le livreur_id seulement quand il prend en charge (en_cours)
    // Si l'admin change le statut, on ne réassigne pas
    let updateQuery;
    let params;

    if (req.user.role === 'livreur' && statut === 'en_cours') {
      updateQuery = 'UPDATE livraisons SET statut = ?, notes = ?, livreur_id = ? WHERE id = ?';
      params = [statut, notes || null, req.user.id, req.params.id];
    } else {
      updateQuery = 'UPDATE livraisons SET statut = ?, notes = ? WHERE id = ?';
      params = [statut, notes || null, req.params.id];
    }

    await pool.query(updateQuery, params);

    if (statut === 'livree') {
      const [liv] = await pool.query('SELECT commande_id FROM livraisons WHERE id = ?', [req.params.id]);
      if (liv.length) {
        await pool.query('UPDATE commandes SET statut = "livree" WHERE id = ?', [liv[0].commande_id]);
      }
    }

    res.json({ message: 'Statut livraison mis à jour.' });
  } catch (err) { next(err); }
}

module.exports = { getAll, getById, updateStatut };