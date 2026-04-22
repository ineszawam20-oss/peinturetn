require('dotenv').config();
const express    = require('express');
const cors       = require('cors');
const helmet     = require('helmet');
const morgan     = require('morgan');
const rateLimit  = require('express-rate-limit');
const path       = require('path');

// ===== Import des routes =====
const matieresPremieresRoutes = require('./routes/matieres-premieres.routes');
const authRoutes          = require('./routes/auth.routes');
const produitsRoutes      = require('./routes/produits.routes');
const commandesRoutes     = require('./routes/commandes.routes');
const livraisonsRoutes    = require('./routes/livraisons.routes');
const devisRoutes         = require('./routes/devis.routes');
const utilisateursRoutes  = require('./routes/utilisateurs.routes');
const lotsRoutes          = require('./routes/lots.routes');
const chantiersRoutes     = require('./routes/chantiers.routes');
const avisRoutes          = require('./routes/avis.routes');
const chatRoutes          = require('./routes/chat.routes');

// ===== Import middleware erreurs =====
const errorHandler = require('./middlewares/errorHandler');

const app  = express();
const PORT = process.env.PORT || 3001;

// ===== Sécurité =====
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      "default-src":  ["'self'"],
      "script-src":   [
        "'self'",
        "'unsafe-inline'",
        "https://cdn.jsdelivr.net",
        "https://cdnjs.cloudflare.com",
        "https://fonts.googleapis.com",
        "https://www.youtube.com",
        "https://s.ytimg.com",
        "https://unpkg.com"
      ],
      "script-src-attr": ["'unsafe-inline'"],
      "style-src":    [
        "'self'",
        "'unsafe-inline'",
        "https://fonts.googleapis.com",
        "https://cdn.jsdelivr.net",
        "https://cdnjs.cloudflare.com",
        "https://unpkg.com"
      ],
      "font-src":     [
        "'self'",
        "https://fonts.gstatic.com",
        "https://cdnjs.cloudflare.com"
      ],
      "img-src":      ["'self'", "data:", "blob:", "https:"],
      "connect-src":  [
        "'self'",
        "http://localhost:3001",
        "https://generativelanguage.googleapis.com",
        "https://cdn.jsdelivr.net",
        "https://unpkg.com"   // ← SEUL AJOUT (cette ligne)
      ],
      "frame-src":    [
        "'self'",
        "https://www.youtube.com",
        "https://drive.google.com",
        "https://accounts.google.com"
      ],
      "frame-ancestors": ["'self'"],
      "media-src":    ["'self'", "blob:", "data:"],
      "worker-src":   ["'self'", "blob:"],
    }
  },
  crossOriginEmbedderPolicy: false,
}));

app.use(cors({
  origin:      process.env.NODE_ENV === 'production' ? 'https://peinturepro.tn' : '*',
  credentials: true
}));

// ===== Rate limiting =====
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
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
app.use('/client',     express.static(path.join(__dirname, '../peinturepro-frontend/client')));
app.use('/css',        express.static(path.join(__dirname, '../peinturepro-frontend/css')));
app.use('/js',         express.static(path.join(__dirname, '../peinturepro-frontend/js')));
app.use('/admin',      express.static(path.join(__dirname, '../peinturepro-frontend/admin')));
app.use('/livreur',    express.static(path.join(__dirname, '../peinturepro-frontend/livreur')));
app.use('/commercial', express.static(path.join(__dirname, '../peinturepro-frontend/commercial')));

// ===== Routes API =====
app.use('/api/auth',               authRoutes);
app.use('/api/produits',           produitsRoutes);
app.use('/api/commandes',          commandesRoutes);
app.use('/api/livraisons',         livraisonsRoutes);
app.use('/api/devis',              devisRoutes);
app.use('/api/utilisateurs',       utilisateursRoutes);
app.use('/api/lots',               lotsRoutes);
app.use('/api/chantiers',          chantiersRoutes);
app.use('/api/matieres-premieres', matieresPremieresRoutes);
app.use('/api/avis',               avisRoutes);
app.use('/api/chat',               chatRoutes);

// ===== Route santé =====
app.get('/api/health', (req, res) => {
  res.json({
    status:  'OK',
    projet:  'PeinturePro TN',
    version: '1.0.0',
    date:    new Date().toISOString()
  });
});
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../peinturepro-frontend', 'index.html'));
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