// const pool = require('../config/dbConfig');
import pool from '../config/database'

const findUserByGoogleId = async (googleId) => {
  const [rows] = pool.query('SELECT * FROM utilisateur WHERE id_google = ?', [googleId]);
  return rows[0];
};

const createUser = async (googleId, email) => {
  const [result] = pool.query('INSERT INTO utilisateur (id_google, email) VALUES (?, ?)', [googleId, email]);
  return result.insertId;
};

export default { findUserByGoogleId, createUser };
