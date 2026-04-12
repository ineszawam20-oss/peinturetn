const pool = require('../config/db');

async function getAll(req, res, next) {
  try {
    let query  = `SELECT c.*, u.nom AS client_nom FROM commandes c
                  JOIN utilisateurs u ON c.client_id = u.id`;
    const params = [];

    // Client voit seulement ses commandes
    if (req.user.role === 'client') {
      query += ' WHERE c.client_id = ?';
      params.push(req.user.id);
    }
    query += ' ORDER BY c.created_at DESC';

    const [rows] = await pool.query(query, params);
    res.json(rows);
  } catch (err) { next(err); }
}

async function getById(req, res, next) {
  try {
    const [rows] = await pool.query(
      `SELECT c.*, u.nom AS client_nom FROM commandes c
       JOIN utilisateurs u ON c.client_id = u.id WHERE c.id = ?`,
      [req.params.id]
    );
    if (!rows.length) return res.status(404).json({ message: 'Commande introuvable.' });

    // Récupérer les détails de la commande
    const [details] = await pool.query(
      `SELECT cd.*, p.nom AS produit_nom FROM commande_details cd
       JOIN produits p ON cd.produit_id = p.id WHERE cd.commande_id = ?`,
      [req.params.id]
    );
    res.json({ ...rows[0], details });
  } catch (err) { next(err); }
}

async function create(req, res, next) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const { produit_id, surface_m2, litres_calcules, date_livraison_souhaitee, chantier_id } = req.body;
    if (litres_calcules < 5)
      return res.status(400).json({ message: 'Minimum 5 litres requis.' });

    // Récupérer le prix du produit
    const [produit] = await conn.query('SELECT * FROM produits WHERE id = ?', [produit_id]);
    if (!produit.length) return res.status(404).json({ message: 'Produit introuvable.' });

    const montant_total = produit[0].prix_litre * litres_calcules;

    // Créer la commande
    const [result] = await conn.query(
      `INSERT INTO commandes (client_id, surface_m2, litres_calcules, montant_total, statut, date_livraison_souhaitee)
       VALUES (?, ?, ?, ?, 'en_attente', ?)`,
      [req.user.id, surface_m2, litres_calcules, montant_total, date_livraison_souhaitee]
    );

    // Créer le détail
    await conn.query(
      'INSERT INTO commande_details (commande_id, produit_id, quantite_litres, prix_litre) VALUES (?, ?, ?, ?)',
      [result.insertId, produit_id, litres_calcules, produit[0].prix_litre]
    );

    await conn.commit();
    res.status(201).json({ message: 'Commande créée.', id: result.insertId, montant_total });

  } catch (err) { await conn.rollback(); next(err); }
  finally        { conn.release(); }
}

async function updateStatut(req, res, next) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const { statut } = req.body;
    const validStatuts = ['en_attente', 'confirmee', 'en_cours', 'livree', 'annulee'];
    if (!validStatuts.includes(statut))
      return res.status(400).json({ message: 'Statut invalide.' });

    await conn.query('UPDATE commandes SET statut = ? WHERE id = ?', [statut, req.params.id]);

    // Si confirmée → créer automatiquement une livraison
    if (statut === 'confirmee') {
      const [commande] = await conn.query('SELECT * FROM commandes WHERE id = ?', [req.params.id]);
      if (commande.length) {
        await conn.query(
          `INSERT INTO livraisons (commande_id, chantier_id, statut)
           VALUES (?, ?, 'planifiee')`,
          [req.params.id, commande[0].chantier_id || null]
        );
      }
    }

    await conn.commit();
    res.json({ message: 'Statut mis à jour.' });

  } catch (err) { await conn.rollback(); next(err); }
  finally        { conn.release(); }
}

async function remove(req, res, next) {
  try {
    await pool.query('DELETE FROM commandes WHERE id = ?', [req.params.id]);
    res.json({ message: 'Commande supprimée.' });
  } catch (err) { next(err); }
}

module.exports = { getAll, getById, create, updateStatut, remove };