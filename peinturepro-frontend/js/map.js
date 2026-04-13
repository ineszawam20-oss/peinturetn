// ============================================
// PeinturePro TN — Leaflet Map Helpers
// ============================================

const MapHelper = {

  map: null,
  markers: [],

  // Initialiser la carte
  init(containerId, lat = 36.8065, lng = 10.1815, zoom = 7) {
    if (this.map) { this.map.remove(); this.map = null; }
    this.map = L.map(containerId).setView([lat, lng], zoom);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors',
      maxZoom: 19
    }).addTo(this.map);
    return this.map;
  },

  // Ajouter un marqueur
  addMarker(lat, lng, label, color = '#C8441A', onClick = null) {
    if (!this.map) return null;
    const icon = L.divIcon({
      html: `<div style="
        background:${color};
        color:white;
        border-radius:50%;
        width:32px; height:32px;
        display:flex; align-items:center; justify-content:center;
        font-size:14px;
        box-shadow:0 3px 10px rgba(0,0,0,.3);
        border:2px solid white;
        cursor:pointer;
        transition: transform .2s;
      ">📍</div>`,
      className: '',
      iconSize:   [32, 32],
      iconAnchor: [16, 32]
    });

    const marker = L.marker([lat, lng], { icon })
      .addTo(this.map)
      .bindPopup(`
        <div style="font-family:sans-serif; min-width:150px;">
          <strong style="color:#1A1108">${label}</strong>
        </div>
      `);

    if (onClick) marker.on('click', onClick);
    this.markers.push(marker);
    return marker;
  },

  // Ajouter marqueur livraison avec statut coloré
  addLivraisonMarker(lat, lng, label, statut, onClick = null) {
    const colors = {
      planifiee: '#7C3AED',
      en_cours:  '#10B981',
      livree:    '#6B7280'
    };
    const icons = {
      planifiee: '📋',
      en_cours:  '🚚',
      livree:    '✅'
    };
    const color = colors[statut] || '#C8441A';
    const emoji = icons[statut]  || '📍';

    if (!this.map) return null;
    const icon = L.divIcon({
      html: `<div style="
        background:${color};
        color:white;
        border-radius:50%;
        width:36px; height:36px;
        display:flex; align-items:center; justify-content:center;
        font-size:16px;
        box-shadow:0 3px 12px rgba(0,0,0,.35);
        border:2px solid white;
        cursor:pointer;
      ">${emoji}</div>`,
      className: '',
      iconSize:   [36, 36],
      iconAnchor: [18, 36]
    });

    const marker = L.marker([lat, lng], { icon })
      .addTo(this.map)
      .bindPopup(`
        <div style="font-family:sans-serif; min-width:180px; padding:4px;">
          <strong style="color:#1A1108; display:block; margin-bottom:4px;">${label}</strong>
          <span style="
            background:${color}20; color:${color};
            padding:2px 8px; border-radius:20px;
            font-size:11px; font-weight:600;
          ">${statut.replace('_', ' ')}</span>
        </div>
      `);

    if (onClick) marker.on('click', onClick);
    this.markers.push(marker);
    return marker;
  },

  // Supprimer tous les marqueurs
  clearMarkers() {
    if (!this.map) return;
    this.markers.forEach(m => this.map.removeLayer(m));
    this.markers = [];
  },

  // Zoomer sur un point
  flyTo(lat, lng, zoom = 14) {
    if (!this.map) return;
    this.map.flyTo([lat, lng], zoom, { duration: 1.2 });
  },

  // Adapter la vue à tous les marqueurs
  fitAll() {
    if (!this.map || !this.markers.length) return;
    const group = L.featureGroup(this.markers);
    this.map.fitBounds(group.getBounds().pad(.2));
  },

  // Tracer une route entre deux points
  drawRoute(lat1, lng1, lat2, lng2, color = '#C8441A') {
    if (!this.map) return;
    const line = L.polyline(
      [[lat1, lng1], [lat2, lng2]],
      { color, weight: 3, opacity: .7, dashArray: '8, 6' }
    ).addTo(this.map);
    return line;
  },

  // Cercle de zone
  addZone(lat, lng, radius = 500, color = '#10B981') {
    if (!this.map) return;
    return L.circle([lat, lng], {
      color,
      fillColor: color,
      fillOpacity: .1,
      radius
    }).addTo(this.map);
  },

  // Coordonnées des grandes villes tunisiennes (fallback)
  villesTN: {
    'Tunis':     { lat: 36.8065, lng: 10.1815 },
    'Sfax':      { lat: 34.7406, lng: 10.7603 },
    'Sousse':    { lat: 35.8289, lng: 10.6399 },
    'Kairouan':  { lat: 35.6781, lng: 10.0963 },
    'Bizerte':   { lat: 37.2744, lng: 9.8739  },
    'Gabès':     { lat: 33.8814, lng: 10.0982 },
    'Ariana':    { lat: 36.8625, lng: 10.1956 },
    'Nabeul':    { lat: 36.4561, lng: 10.7376 },
    'Monastir':  { lat: 35.7643, lng: 10.8113 },
    'Ben Arous': { lat: 36.7533, lng: 10.2328 }
  },

  // Obtenir coordonnées d'une ville
  getCoordsVille(ville) {
    return this.villesTN[ville] || this.villesTN['Tunis'];
  }
};