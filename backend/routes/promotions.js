const express = require('express');
const router = express.Router();
const pool = require('../config/db');

const multer = require('multer');
const path = require('path');

// ==== Cấu hình upload giống products.js ====
const storage = multer.diskStorage({
  destination: './public/images/', // nhớ bảo đảm thư mục tồn tại
  filename: (req, file, cb) => {
    cb(null, file.originalname); // giữ nguyên tên file
  }
});
const upload = multer({ storage });

// ================== API ==================

// 1) Upload ảnh cho promotion -> trả về URL tuyệt đối
// POST /api/promotions/upload  (form-data: image=<file>)
router.post('/upload', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'Vui lòng chọn một file ảnh' });
    }
    const imageUrl = `${req.protocol}://${req.get('host')}/images/${req.file.originalname}`;
    return res.status(200).json({ message: 'Tải ảnh thành công', imageUrl });
  } catch (err) {
    console.error('Upload promotion image error:', err);
    return res.status(500).json({ error: 'Tải ảnh thất bại' });
  }
});

// 2) Cập nhật đường dẫn ảnh cho một promotion có sẵn
// PUT /api/promotions/:id/image  (JSON: { "imageUrl": "..." })
router.put('/:id/image', async (req, res) => {
  const { id } = req.params;
  const { imageUrl } = req.body;

  if (!imageUrl) {
    return res.status(400).json({ error: 'Vui lòng cung cấp đường dẫn ảnh' });
  }

  try {
    const [result] = await pool.query(
      'UPDATE promotions SET image_url = ? WHERE id = ?',
      [imageUrl, id]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Khuyến mãi không tồn tại' });
    }
    return res.status(200).json({ message: 'Cập nhật ảnh khuyến mãi thành công' });
  } catch (err) {
    console.error('Update promotion image error:', err);
    return res.status(500).json({ error: 'Cập nhật ảnh thất bại' });
  }
});

// 3) Lấy danh sách promotions (có lọc active)
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

    // (tuỳ chọn) Nếu image_url là tên file trần, tự build URL tuyệt đối để Flutter hiển thị được
    const host = `${req.protocol}://${req.get('host')}`;
    const data = rows.map(r => {
      let url = r.image_url || '';
      if (!/^https?:\/\//i.test(url)) {
        // nếu người dùng chỉ lưu "banner.png" thì chuyển thành "/images/banner.png"
        if (!url.startsWith('/')) url = '/images/' + url;
        url = host + url;
      }
      return { ...r, image_url: url };
    });

    res.json(data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'DB error' });
  }
});

module.exports = router;
