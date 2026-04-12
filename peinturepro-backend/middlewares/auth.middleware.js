const jwt        = require('jsonwebtoken');
const jwtConfig  = require('../config/jwt');

function verifyToken(req, res, next) {
  try {
    // Récupérer le token dans le header Authorization: Bearer <token>
    const authHeader = req.headers['authorization'];
    const token      = authHeader && authHeader.split(' ')[1];

    if (!token) {
      return res.status(401).json({ message: 'Accès refusé. Token manquant.' });
    }

    // Vérifier et décoder le token
    const decoded = jwt.verify(token, jwtConfig.secret);
    req.user      = decoded;
    next();

  } catch (err) {
    if (err.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Token expiré.', expired: true });
    }
    return res.status(401).json({ message: 'Token invalide.' });
  }
}

module.exports = { verifyToken };