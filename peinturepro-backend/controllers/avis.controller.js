const pool = require('../config/db');

exports.getAll = async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT a.id, a.message, a.note, a.created_at, u.nom as client_nom 
            FROM avis a 
            JOIN utilisateurs u ON a.client_id = u.id 
            ORDER BY a.created_at DESC
        `);
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur' });
    }
};

exports.create = async (req, res) => {
    try {
        const { message, note } = req.body;
        const client_id = req.user.id; // vient du token
        if (!message || !note || note < 1 || note > 5) {
            return res.status(400).json({ message: 'Message et note (1-5) requis' });
        }
        const [result] = await pool.query(
            'INSERT INTO avis (client_id, message, note) VALUES (?, ?, ?)',
            [client_id, message, note]
        );
        res.status(201).json({ id: result.insertId, message: 'Avis ajouté avec succès' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur' });
    }
};

exports.remove = async (req, res) => {
    try {
        const { id } = req.params;
        await pool.query('DELETE FROM avis WHERE id = ?', [id]);
        res.status(204).send();
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur' });
    }
};