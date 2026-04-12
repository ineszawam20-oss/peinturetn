require('dotenv').config();
const express    = require('express');
const cors       = require('cors');
const helmet     = require('helmet');
const morgan     = require('morgan');
const rateLimit  = require('express-rate-limit');
const path       = require('path');

// ===== Import des routes =====
const authRoutes          = require('./routes/auth.routes');
const produitsRoutes      = require('./routes/produits.routes');
const commandesRoutes     = require('./routes/commandes.routes');
const livraisonsRoutes    = require('./routes/livraisons.routes');
const devisRoutes         = require('./routes/devis.routes');
const utilisateursRoutes  = require('./routes/utilisateurs.routes');
const lotsRoutes          = require('./routes/lots.routes');
const chantiersRoutes     = require('./routes/chantiers.routes');

// ===== Import middleware erreurs =====
const errorHandler = require('./middlewares/errorHandler');

const app  = express();
const PORT = process.env.PORT || 3000;

// ===== Sécurité =====
app.use(helmet({
  contentSecurityPolicy: false,
  crossOriginEmbedderPolicy: false
}));
app.use(cors({
  origin:      process.env.NODE_ENV === 'production' ? 'https://peinturepro.tn' : '*',
  credentials: true
}));


// ===== Rate limiting =====
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max:      100,
  message:  { message: 'Trop de requêtes, réessayez dans 15 minutes.' }
});
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max:      10,
  message:  { message: 'Trop de tentatives de connexion.' }
});
app.use('/api/', limiter);
app.use('/api/auth/login',           authLimiter);
app.use('/api/auth/forgot-password', authLimiter);

// ===== Parsing =====
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ===== Logs =====
if (process.env.NODE_ENV !== 'test') {
  app.use(morgan('dev'));
}


// ===== Fichiers statiques (frontend) =====
app.use(express.static(path.join(__dirname, '../peinturepro-frontend')));
app.use('/client',  express.static(path.join(__dirname, '../peinturepro-frontend/client')));
app.use('/css',     express.static(path.join(__dirname, '../peinturepro-frontend/css')));
app.use('/js',      express.static(path.join(__dirname, '../peinturepro-frontend/js')));
app.use('/admin',   express.static(path.join(__dirname, '../peinturepro-frontend/admin')));
app.use('/livreur', express.static(path.join(__dirname, '../peinturepro-frontend/livreur')));
app.use('/commercial', express.static(path.join(__dirname, '../peinturepro-frontend/commercial')));

// ===== Routes API =====
app.use('/api/auth',          authRoutes);
app.use('/api/produits',      produitsRoutes);
app.use('/api/commandes',     commandesRoutes);
app.use('/api/livraisons',    livraisonsRoutes);
app.use('/api/devis',         devisRoutes);
app.use('/api/utilisateurs',  utilisateursRoutes);
app.use('/api/lots',          lotsRoutes);
app.use('/api/chantiers',     chantiersRoutes);

// ===== Route santé =====
app.get('/api/health', (req, res) => {
  res.json({
    status:  'OK',
    projet:  'PeinturePro TN',
    version: '1.0.0',
    date:    new Date().toISOString()
  });
});

// ===== 404 =====
app.use((req, res) => {
  res.status(404).json({ message: `Route ${req.originalUrl} introuvable.` });
});

// ===== Gestionnaire d'erreurs global =====
app.use(errorHandler);

// ===== Démarrage =====
app.listen(PORT, () => {
  console.log('========================================');
  console.log(`🚀 PeinturePro TN démarré`);
  console.log(`📡 http://localhost:${PORT}`);
  console.log(`🌍 Environnement : ${process.env.NODE_ENV}`);
  console.log('========================================');
});

module.exports = app;