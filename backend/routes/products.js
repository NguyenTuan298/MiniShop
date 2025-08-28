const express = require('express');
const router = express.Router();
const { sql, poolPromise } = require('../config/db');  // Giả sử bạn có config/db.js như trước

// GET /api/products - Lấy danh sách sản phẩm theo category (optional)
router.get('/products', async (req, res) => {
  const { category } = req.query;
  console.log('Query category:', category); // Log tham số
  try {
    const pool = await poolPromise;
    let query = 'SELECT * FROM Products';
    const request = pool.request();

    if (category) {
      query += ' WHERE category = @category';
      request.input('category', sql.NVarChar, category); // Thêm tham số đúng cách
      console.log('SQL Query:', query); // Log query
    }
    query += ' ORDER BY created_at DESC';
    
    const result = await request.query(query);
    console.log('Query Result:', result.recordset); // Log kết quả
    if (result.recordset.length === 0 && category) {
      return res.status(404).json({ error: 'Không tìm thấy sản phẩm trong danh mục này' });
    }
    res.status(200).json({ products: result.recordset, message: 'Lấy sản phẩm thành công' });
  } catch (err) {
    console.error('Get products error:', err); // Log lỗi chi tiết
    res.status(500).json({ error: 'Lấy sản phẩm thất bại' });
  }
});

// GET /api/products/:id - Lấy chi tiết sản phẩm
router.get('/products/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const pool = await poolPromise;
    const result = await pool.request()
      .input('id', sql.Int, id)
      .query('SELECT * FROM Products WHERE id = @id');
    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'Sản phẩm không tồn tại' });
    }
    res.status(200).json({ product: result.recordset[0], message: 'Lấy chi tiết sản phẩm thành công' });
  } catch (err) {
    console.error('Get product detail error:', err);
    res.status(500).json({ error: 'Lấy chi tiết sản phẩm thất bại' });
  }
});

// POST /api/products - Thêm sản phẩm mới (admin)
router.post('/products', async (req, res) => {
  const { name, category, description, price, image_url, stock } = req.body;
  if (!name || !category || !price) {
    return res.status(400).json({ error: 'Vui lòng nhập đầy đủ thông tin bắt buộc' });
  }
  try {
    const pool = await poolPromise;
    await pool.request()
      .input('name', sql.NVarChar, name)
      .input('category', sql.NVarChar, category)
      .input('description', sql.NVarChar, description || null)
      .input('price', sql.Decimal(10, 2), price)
      .input('image_url', sql.NVarChar, image_url || null)
      .input('stock', sql.Int, stock || 0)
      .query('INSERT INTO Products (name, category, description, price, image_url, stock) VALUES (@name, @category, @description, @price, @image_url, @stock)');
    res.status(201).json({ message: 'Thêm sản phẩm thành công' });
  } catch (err) {
    console.error('Add product error:', err);
    res.status(500).json({ error: 'Thêm sản phẩm thất bại' });
  }
});

// PUT /api/products/:id - Cập nhật sản phẩm
router.put('/products/:id', async (req, res) => {
  const { id } = req.params;
  const { name, category, description, price, image_url, stock } = req.body;
  try {
    const pool = await poolPromise;
    const result = await pool.request()
      .input('id', sql.Int, id)
      .input('name', sql.NVarChar, name)
      .input('category', sql.NVarChar, category)
      .input('description', sql.NVarChar, description)
      .input('price', sql.Decimal(10, 2), price)
      .input('image_url', sql.NVarChar, image_url)
      .input('stock', sql.Int, stock)
      .query('UPDATE Products SET name = @name, category = @category, description = @description, price = @price, image_url = @image_url, stock = @stock WHERE id = @id');
    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ error: 'Sản phẩm không tồn tại' });
    }
    res.status(200).json({ message: 'Cập nhật sản phẩm thành công' });
  } catch (err) {
    console.error('Update product error:', err);
    res.status(500).json({ error: 'Cập nhật sản phẩm thất bại' });
  }
});

// DELETE /api/products/:id - Xóa sản phẩm
router.delete('/products/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const pool = await poolPromise;
    const result = await pool.request()
      .input('id', sql.Int, id)
      .query('DELETE FROM Products WHERE id = @id');
    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ error: 'Sản phẩm không tồn tại' });
    }
    res.status(200).json({ message: 'Xóa sản phẩm thành công' });
  } catch (err) {
    console.error('Delete product error:', err);
    res.status(500).json({ error: 'Xóa sản phẩm thất bại' });
  }
});

module.exports = router;