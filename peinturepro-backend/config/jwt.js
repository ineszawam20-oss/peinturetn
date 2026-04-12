require('dotenv').config();

module.exports = {
  // Access token — courte durée (15 min)
  secret:         process.env.JWT_SECRET,
  expiresIn:      process.env.JWT_EXPIRES_IN || '15m',

  // Refresh token — longue durée (7 jours)
  refreshSecret:  process.env.JWT_REFRESH_SECRET,
  refreshExpires: process.env.JWT_REFRESH_EXPIRES_IN || '7d'
};