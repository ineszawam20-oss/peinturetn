function requireRole(...roles) {
  const flatRoles = roles.flat();
  return (req, res, next) => {
    console.log('=== DEBUG RBAC ===');
    console.log('req.user :', req.user);
    console.log('rôles requis :', flatRoles);
    if (!req.user) {
      console.log('Pas de req.user');
      return res.status(401).json({ message: 'Non authentifié.' });
    }
    console.log('req.user.role :', req.user.role);
    if (!flatRoles.includes(req.user.role)) {
      console.log(`Rôle ${req.user.role} non autorisé`);
      return res.status(403).json({
        message: `Accès interdit. Rôle requis : ${flatRoles.join(' ou ')}.`
      });
    }
    next();
  };
}

module.exports = { requireRole };