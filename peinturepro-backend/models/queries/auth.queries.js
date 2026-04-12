const pool = require('../../config/db');

const AuthQueries = {

  findByEmail: (email) =>
    pool.query('SELECT * FROM utilisateurs WHERE email = ? AND actif = 1', [email]),

  findById: (id) =>
    pool.query('SELECT id, nom, email, role, actif FROM utilisateurs WHERE id = ?', [id]),

  createUser: (nom, email, hash, role, telephone, adresse) =>
    pool.query(
      'INSERT INTO utilisateurs (nom, email, password, role, telephone, adresse, actif) VALUES (?, ?, ?, ?, ?, ?, 1)',
      [nom, email, hash, role, telephone, adresse]
    ),

  saveRefreshToken: (userId, token) =>
    pool.query(
      'INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 7 DAY))',
      [userId, token]
    ),

  findRefreshToken: (token) =>
    pool.query(
      'SELECT * FROM refresh_tokens WHERE token = ? AND revoked = 0 AND expires_at > NOW()',
      [token]
    ),

  revokeRefreshToken: (token) =>
    pool.query('UPDATE refresh_tokens SET revoked = 1 WHERE token = ?', [token]),

  saveResetToken: (userId, token, expires) =>
    pool.query(
      'INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES (?, ?, ?)',
      [userId, token, expires]
    ),

  findResetToken: (token) =>
    pool.query(
      'SELECT * FROM password_reset_tokens WHERE token = ? AND used = 0 AND expires_at > NOW()',
      [token]
    ),

  markResetTokenUsed: (token) =>
    pool.query('UPDATE password_reset_tokens SET used = 1 WHERE token = ?', [token]),

  updatePassword: (userId, hash) =>
    pool.query('UPDATE utilisateurs SET password = ? WHERE id = ?', [hash, userId])
};

module.exports = AuthQueries;