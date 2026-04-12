function errorHandler(err, req, res, next) {
  console.error('❌ Erreur :', err.message);

  // Erreur de validation Joi
  if (err.isJoi) {
    return res.status(400).json({
      message: 'Données invalides.',
      details: err.details.map(d => d.message)
    });
  }

  // Erreur MySQL
  if (err.code === 'ER_DUP_ENTRY') {
    return res.status(409).json({ message: 'Cette entrée existe déjà.' });
  }

  if (err.code === 'ER_NO_REFERENCED_ROW_2') {
    return res.status(400).json({ message: 'Référence inexistante en base.' });
  }

  // Erreur générique
  const status  = err.status  || 500;
  const message = err.message || 'Erreur interne du serveur.';

  res.status(status).json({
    message,
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
}

module.exports = errorHandler;