const express = require('express');
const router = express.Router();
const pool = require('../config/db');

// GET /api/promotions?active=1&limit=10
router.get('/', async (req, res) => {
  try {
    const isActive = (req.query.active === '1' || req.query.active === 'true');
    const limit = Math.min(parseInt(req.query.limit || '10', 10), 50);

    let sql = `
      SELECT id,title,subtitle,description,image_url,discount_percent,start_at,end_at
      FROM promotions
    `;
    const params = [];

    if (isActive) {
      sql += `WHERE is_active=1 AND CURRENT_DATE() BETWEEN start_at AND end_at `;
    }

    sql += `ORDER BY start_at DESC, id DESC LIMIT ?`;
    params.push(limit);

    const [rows] = await pool.query(sql, params);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'DB error' });
  }
});

module.exports = router;
