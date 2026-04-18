const db = require('../config/db');

// GET toutes les matières premières
exports.getAll = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM matieres_premieres ORDER BY nom');
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// GET une matière par ID
exports.getById = async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await db.query('SELECT * FROM matieres_premieres WHERE id = ?', [id]);
    if (rows.length === 0) return res.status(404).json({ message: 'Matière non trouvée' });
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// POST créer une matière
exports.create = async (req, res) => {
  const { nom, unite, stock_actuel, stock_minimum } = req.body;
  if (!nom || !unite) {
    return res.status(400).json({ message: 'Nom et unité sont requis' });
  }
  try {
    const [result] = await db.query(
      'INSERT INTO matieres_premieres (nom, unite, stock_actuel, stock_minimum) VALUES (?, ?, ?, ?)',
      [nom, unite, stock_actuel || 0, stock_minimum || 0]
    );
    const [newRow] = await db.query('SELECT * FROM matieres_premieres WHERE id = ?', [result.insertId]);
    res.status(201).json(newRow[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// PUT modifier une matière
exports.update = async (req, res) => {
  const { id } = req.params;
  const { nom, unite, stock_actuel, stock_minimum } = req.body;
  try {
    const [existing] = await db.query('SELECT * FROM matieres_premieres WHERE id = ?', [id]);
    if (existing.length === 0) return res.status(404).json({ message: 'Matière non trouvée' });
    
    await db.query(
      'UPDATE matieres_premieres SET nom = ?, unite = ?, stock_actuel = ?, stock_minimum = ? WHERE id = ?',
      [nom || existing[0].nom, unite || existing[0].unite, stock_actuel ?? existing[0].stock_actuel, stock_minimum ?? existing[0].stock_minimum, id]
    );
    const [updated] = await db.query('SELECT * FROM matieres_premieres WHERE id = ?', [id]);
    res.json(updated[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// DELETE supprimer une matière
exports.remove = async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await db.query('DELETE FROM matieres_premieres WHERE id = ?', [id]);
    if (result.affectedRows === 0) return res.status(404).json({ message: 'Matière non trouvée' });
    res.status(204).send();
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};