// ============================================
// PeinturePro TN — Intercepteur HTTP
// Gestion automatique JWT + Refresh Token
// ============================================

const API_URL = window.location.origin + '/api';

// ===== Helpers Token =====
const Auth = {
  getToken:        () => localStorage.getItem('token'),
  getRefreshToken: () => localStorage.getItem('refreshToken'),
  getUser:         () => JSON.parse(localStorage.getItem('user') || 'null'),
  getRole:         () => localStorage.getItem('role'),

  setSession: (data) => {
    localStorage.setItem('token',        data.token);
    localStorage.setItem('refreshToken', data.refreshToken);
    localStorage.setItem('user',         JSON.stringify(data.user));
    localStorage.setItem('role',         data.user.role);
  },

  clearSession: () => {
    localStorage.removeItem('token');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('user');
    localStorage.removeItem('role');
  },

  isLoggedIn: () => !!localStorage.getItem('token'),

  redirectToLogin: () => {
    Auth.clearSession();
    window.location.href = '/login-client.html';
  }
};

// ===== Refresh Token =====
async function refreshAccessToken() {
  const refreshToken = Auth.getRefreshToken();
  if (!refreshToken) throw new Error('Pas de refresh token');

  const res  = await fetch(`${API_URL}/auth/refresh`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json' },
    body:    JSON.stringify({ refreshToken })
  });

  if (!res.ok) throw new Error('Refresh échoué');

  const data = await res.json();
  localStorage.setItem('token', data.token);
  return data.token;
}

// ===== Requête principale avec auto-refresh =====
async function apiRequest(endpoint, options = {}) {
const makeRequest = async (token) => {
  console.log('REQUEST:', options.method || 'GET', endpoint, 'TOKEN:', token?.substring(0, 20));
  const res = await fetch(`${API_URL}${endpoint}`, {
    ...options,
    headers: {
      'Content-Type':  'application/json',
      'Authorization': `Bearer ${token}`,
      ...options.headers
    }
  });
  console.log('RESPONSE:', endpoint, res.status);
  return res;
};

  let token = Auth.getToken();
  let res   = await makeRequest(token);

  // Token expiré → on rafraîchit automatiquement
  if (res.status === 401) {
    const data = await res.json();
    if (data.expired) {
      try {
        token = await refreshAccessToken();
        res   = await makeRequest(token);
      } catch {
        Auth.redirectToLogin();
        return;
      }
    } else {
      Auth.redirectToLogin();
      return;
    }
  }

  return res;
}

// ===== Méthodes HTTP simplifiées =====
const api = {
  get: (endpoint) =>
    apiRequest(endpoint, { method: 'GET' }),

  post: (endpoint, body) =>
    apiRequest(endpoint, {
      method: 'POST',
      body:   JSON.stringify(body)
    }),

  put: (endpoint, body) =>
    apiRequest(endpoint, {
      method: 'PUT',
      body:   JSON.stringify(body)
    }),

  delete: (endpoint) =>
    apiRequest(endpoint, { method: 'DELETE' })
};

// ===== Logout =====
async function logout() {
  try {
    await api.post('/auth/logout', { refreshToken: Auth.getRefreshToken() });
  } catch {}
  Auth.clearSession();
  window.location.href = '/login-client.html';
}

// ===== Guard de route =====
function requireAuth(allowedRoles = []) {
  if (!Auth.isLoggedIn()) {
    Auth.redirectToLogin();
    return false;
  }
  if (allowedRoles.length && !allowedRoles.includes(Auth.getRole())) {
    alert('Accès interdit.');
    history.back();
    return false;
  }
  return true;
}
