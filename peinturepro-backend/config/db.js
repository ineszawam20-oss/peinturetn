const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host:            process.env.DB_HOST,
  port:            process.env.DB_PORT,
  database:        process.env.DB_NAME,
  user:            process.env.DB_USER,
  password:        process.env.DB_PASSWORD,
  waitForConnections: true,
  connectionLimit:    10,
  queueLimit:         0,
  timezone:           '+01:00'
});

// Test de connexion au démarrage
async function testConnection() {
  try {
    const conn = await pool.getConnection();
    console.log('✅ MySQL connecté avec succès');
    conn.release();
  } catch (err) {
    console.error('❌ Erreur connexion MySQL :', err.message);
    process.exit(1);
  }
}

testConnection();

module.exports = pool;