// ============================================
// PeinturePro TN — Auth Helper
// ============================================

async function handleLogin(email, password, role = 'client') {
  const res  = await fetch(`${API_URL}/auth/login`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json' },
    body:    JSON.stringify({ email, password, role })
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || 'Erreur de connexion');

  Auth.setSession(data);
  return data;
}

async function handleRegister(formData) {
  const res  = await fetch(`${API_URL}/auth/register`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json' },
    body:    JSON.stringify(formData)
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || 'Erreur inscription');
  return data;
}

// Affiche le nom de l'utilisateur connecté
function displayUserInfo(selector = '#userName') {
  const user = Auth.getUser();
  const el   = document.querySelector(selector);
  if (el && user) el.textContent = user.nom;
}

// Redirige selon le rôle après login
function redirectByRole(role) {
  const routes = {
    admin:      '/admin/dashboard.html',
    commercial: '/commercial/dashboard.html',
    livreur:    '/livreur/dashboard.html',
    client:     '/client/catalogue.html'
  };
  window.location.href = routes[role] || '/';
}