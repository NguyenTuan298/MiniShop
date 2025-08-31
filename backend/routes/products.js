const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: './public/images/',
  filename: (req, file, cb) => {
    cb(null, file.originalname); // Sử dụng tên file gốc
  }
});
const upload = multer({ storage: storage });

// Route để tải ảnh lên
router.post('/products/upload', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'Vui lòng chọn một file ảnh' });
    }
    const imageUrl = `${req.protocol}://${req.get('host')}/images/${req.file.originalname}`;
    res.status(200).json({ message: 'Tải ảnh thành công', imageUrl });
  } catch (err) {
    console.error('Upload error:', err);
    res.status(500).json({ error: 'Tải ảnh thất bại' });
  }
});


router.get('/products', async (req, res) => {
  const { category } = req.query;
  console.log('Query category:', category);
  try {
    const query = 'SELECT * FROM products' + (category ? ' WHERE category = ?' : '');
    const [result] = await pool.query(query, category ? [category] : []);
    console.log('Query Result:', result);
    if (result.length === 0 && category) {
      return res.status(404).json({ error: 'Không tìm thấy sản phẩm trong danh mục này' });
    }
    res.status(200).json({ products: result, message: 'Lấy sản phẩm thành công' });
  } catch (err) {
    console.error('Get products error:', err);
    res.status(500).json({ error: 'Lấy sản phẩm thất bại' });
  }
});

router.put('/products/:id/image', async (req, res) => {
  const { id } = req.params;
  const { imageUrl } = req.body;

  if (!imageUrl) {
    return res.status(400).json({ error: 'Vui lòng cung cấp đường dẫn ảnh' });
  }

  try {
    const [result] = await pool.query(
      'UPDATE products SET image_url = ? WHERE id = ?',
      [imageUrl, id]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Sản phẩm không tồn tại' });
    }
    res.status(200).json({ message: 'Cập nhật ảnh thành công' });
  } catch (err) {
    console.error('Update image error:', err);
    res.status(500).json({ error: 'Cập nhật ảnh thất bại' });
  }
});


router.delete('/products/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const [result] = await pool.query(
      'DELETE FROM products WHERE id = ?',
      [id]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Sản phẩm không tồn tại' });
    }
    res.status(200).json({ message: 'Xóa sản phẩm thành công' });
  } catch (err) {
    console.error('Delete product error:', err);
    res.status(500).json({ error: 'Xóa sản phẩm thất bại' });
  }
});

module.exports = router;