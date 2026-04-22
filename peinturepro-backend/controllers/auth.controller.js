const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const jwtConfig = require('../config/jwt');
const pool = require('../config/db');
const { sendResetEmail } = require('../utils/emailSender');

// ===== LOGIN =====
async function login(req, res, next) {
  try {
    const { email, password, role: selectedRole } = req.body;
    if (!email || !password)
      return res.status(400).json({ message: 'Email et mot de passe requis.' });

    const [rows] = await pool.query(
      'SELECT * FROM utilisateurs WHERE email = ? AND actif = 1', [email]
    );
    if (!rows.length)
      return res.status(401).json({ message: 'Identifiants incorrects.' });

    const user = rows[0];
    const match = await bcrypt.compare(password, user.password);
    if (!match)
      return res.status(401).json({ message: 'Identifiants incorrects.' });

    // Vérification du rôle sélectionné (admin peut tout, sinon doit correspondre)
    if (selectedRole && user.role !== 'admin' && user.role !== selectedRole) {
      return res.status(403).json({
        message: `Accès refusé. Vous avez sélectionné le rôle "${selectedRole}", mais cet utilisateur a le rôle "${user.role}".`
      });
    }

    const payload = { id: user.id, role: user.role, nom: user.nom };
    const accessToken = jwt.sign(payload, jwtConfig.secret, { expiresIn: jwtConfig.expiresIn });
    const refreshToken = jwt.sign(payload, jwtConfig.refreshSecret, { expiresIn: jwtConfig.refreshExpires });

    await pool.query(
      'INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 7 DAY))',
      [user.id, refreshToken]
    );

    res.json({
      token: accessToken,
      refreshToken,
      user: { id: user.id, nom: user.nom, email: user.email, role: user.role }
    });
  } catch (err) { next(err); }
}

// ===== REGISTER (client uniquement) =====
async function register(req, res, next) {
  try {
    const { nom, email, password, telephone, adresse } = req.body;
    if (!nom || !email || !password)
      return res.status(400).json({ message: 'Champs obligatoires manquants.' });

    const [existing] = await pool.query(
      'SELECT id FROM utilisateurs WHERE email = ?', [email]
    );
    if (existing.length)
      return res.status(409).json({ message: 'Cet email est déjà utilisé.' });

    const hash = await bcrypt.hash(password, 12);
    const [result] = await pool.query(
      'INSERT INTO utilisateurs (nom, email, password, role, telephone, adresse, actif) VALUES (?, ?, ?, "client", ?, ?, 1)',
      [nom, email, hash, telephone || null, adresse || null]
    );

    res.status(201).json({
      message: 'Compte créé avec succès.',
      userId: result.insertId
    });
  } catch (err) { next(err); }
}

// ===== REFRESH TOKEN =====
async function refresh(req, res, next) {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken)
      return res.status(401).json({ message: 'Refresh token manquant.' });

    const [rows] = await pool.query(
      'SELECT * FROM refresh_tokens WHERE token = ? AND revoked = 0 AND expires_at > NOW()',
      [refreshToken]
    );
    if (!rows.length)
      return res.status(401).json({ message: 'Refresh token invalide ou expiré.' });

    const decoded = jwt.verify(refreshToken, jwtConfig.refreshSecret);
    const payload = { id: decoded.id, role: decoded.role, nom: decoded.nom };
    const accessToken = jwt.sign(payload, jwtConfig.secret, { expiresIn: jwtConfig.expiresIn });

    res.json({ token: accessToken });
  } catch (err) { next(err); }
}

// ===== LOGOUT =====
async function logout(req, res, next) {
  try {
    const { refreshToken } = req.body;
    if (refreshToken) {
      await pool.query('UPDATE refresh_tokens SET revoked = 1 WHERE token = ?', [refreshToken]);
    }
    res.json({ message: 'Déconnexion réussie.' });
  } catch (err) { next(err); }
}

// ===== FORGOT PASSWORD =====
async function forgotPassword(req, res, next) {
  try {
    const { email } = req.body;
    
    // Normalize email: trim whitespace and convert to lowercase
    if (!email || typeof email !== 'string') {
      return res.status(400).json({ message: 'Adresse e-mail requise.' });
    }
    const normalizedEmail = email.trim().toLowerCase();
    
    const [rows] = await pool.query(
      'SELECT id FROM utilisateurs WHERE LOWER(email) = ? AND actif = 1', [normalizedEmail]
    );
    
    // Always return same message to prevent email enumeration
    const successMessage = 'Si cet email existe, un lien a été envoyé.';
    
    if (rows.length) {
      const token = jwt.sign({ id: rows[0].id }, jwtConfig.secret, { expiresIn: '1h' });
      const expires = new Date(Date.now() + 3600000);
      
      // Use frontend URL from environment or default to port 3000
      const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:3000';
      const resetLink = `${frontendUrl}/reset-password.html?token=${token}`;
      
      try {
        // Send email first - only insert token if email succeeds
        await sendResetEmail(normalizedEmail, resetLink);
        
        // Email sent successfully, now store the token
        await pool.query(
          'INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES (?, ?, ?)',
          [rows[0].id, token, expires]
        );
      } catch (emailErr) {
        // No token inserted - no cleanup needed
        console.error('Failed to send reset email:', emailErr.message);
        return res.status(500).json({ message: 'Erreur lors de l\'envoi de l\'email. Veuillez réessayer plus tard.' });
      }
    }
    
    res.json({ message: successMessage });
  } catch (err) { next(err); }
}

// ===== RESET PASSWORD =====
async function resetPassword(req, res, next) {
  try {
    const { token, password } = req.body;
    if (!token || !password)
      return res.status(400).json({ message: 'Token et mot de passe requis.' });

    const [rows] = await pool.query(
      'SELECT * FROM password_reset_tokens WHERE token = ? AND used = 0 AND expires_at > NOW()',
      [token]
    );
    if (!rows.length)
      return res.status(400).json({ message: 'Token invalide ou expiré.' });

    const hash = await bcrypt.hash(password, 12);
    await pool.query('UPDATE utilisateurs SET password = ? WHERE id = ?', [hash, rows[0].user_id]);
    await pool.query('UPDATE password_reset_tokens SET used = 1 WHERE token = ?', [token]);

    res.json({ message: 'Mot de passe réinitialisé avec succès.' });
  } catch (err) { next(err); }
}

// ===== GET TEST CREDENTIALS =====
async function getTestCredentials(req, res, next) {
  try {
    const { role } = req.params;
    const [rows] = await pool.query(
      'SELECT email FROM utilisateurs WHERE role = ? AND actif = 1 LIMIT 1',
      [role]
    );
    if (rows.length === 0) {
      return res.status(404).json({ message: `Aucun utilisateur trouvé pour le rôle ${role}` });
    }
    res.json({ email: rows[0].email });
  } catch (err) { next(err); }
}

module.exports = {
  login,
  register,
  refresh,
  logout,
  forgotPassword,
  resetPassword,
  getTestCredentials
};