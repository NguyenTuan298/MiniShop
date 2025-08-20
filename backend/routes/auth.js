const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { sql, poolPromise } = require('../config/db');


// Không dùng bcrypt
// REGISTER
router.post('/register', async (req, res) => {
  const { phone, name, email, password } = req.body;

  if (!phone || !name || !email || !password) {
    return res.status(400).json({ error: 'Vui lòng nhập đầy đủ thông tin' });
  }

  try {
    const pool = await poolPromise;
    const checkResult = await pool.request()
      .input('email', sql.VarChar, email)
      .input('phone', sql.VarChar, phone)
      .query('SELECT * FROM Users WHERE email = @email OR phone = @phone');

    if (checkResult.recordset.length > 0) {
      return res.status(400).json({ error: 'Email hoặc số điện thoại đã tồn tại' });
    }

    await pool.request()
      .input('phone', sql.VarChar, phone)
      .input('name', sql.NVarChar, name)
      .input('email', sql.VarChar, email)
      .input('password', sql.VarChar, password) // Lưu password gốc
      .query('INSERT INTO Users (phone, name, email, password) VALUES (@phone, @name, @email, @password)');

    res.status(201).json({ message: 'Đăng ký thành công' });
  } catch (err) {
    console.error('Register error:', err);
    res.status(500).json({ error: 'Đăng ký thất bại' });
  }
});

router.post('/login', async (req, res) => {
  console.log('Login request body:', req.body);
  const { phoneEmail, password } = req.body || {};

  if (!phoneEmail || !password) {
    return res.status(400).json({ error: 'Vui lòng nhập đầy đủ thông tin' });
  }

  try {
    const pool = await poolPromise;
    const result = await pool.request()
      .input('phoneEmail', sql.VarChar, phoneEmail)
      .query('SELECT * FROM Users WHERE email = @phoneEmail OR phone = @phoneEmail');

    if (result.recordset.length === 0) {
      return res.status(400).json({ error: 'Tài khoản không tồn tại' });
    }

    const user = result.recordset[0];
    if (user.password !== password) {
      return res.status(400).json({ error: 'Mật khẩu không đúng' });
    }

    const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, { expiresIn: '1h' });
    res.status(200).json({ message: 'Đăng nhập thành công', token });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Đăng nhập thất bại' });
  }
});

module.exports = router;


// Sử dụng bcrypt
//router.post('/register', async (req, res) => {
//  console.log('Register request body:', req.body); // Debug
//  const { phone, name, email, password } = req.body || {};
//
//  if (!phone || !name || !email || !password) {
//    return res.status(400).json({ error: 'Vui lòng nhập đầy đủ thông tin' });
//  }
//
//  try {
//    const pool = await poolPromise;
//    const checkResult = await pool.request()
//      .input('email', sql.VarChar, email)
//      .input('phone', sql.VarChar, phone)
//      .query('SELECT * FROM Users WHERE email = @email OR phone = @phone');
//
//    if (checkResult.recordset.length > 0) {
//      return res.status(400).json({ error: 'Email hoặc số điện thoại đã tồn tại' });
//    }
//
//    const salt = await bcrypt.genSalt(10);
//    const hashedPassword = await bcrypt.hash(password, salt);
//
//    await pool.request()
//      .input('phone', sql.VarChar, phone)
//      .input('name', sql.NVarChar, name)
//      .input('email', sql.VarChar, email)
//      .input('password', sql.VarChar, hashedPassword)
//      .query('INSERT INTO Users (phone, name, email, password) VALUES (@phone, @name, @email, @password)');
//
//    res.status(201).json({ message: 'Đăng ký thành công' });
//  } catch (err) {
//    console.error('Register error:', err);
//    res.status(500).json({ error: 'Đăng ký thất bại' });
//  }
//});

// LOGIN
//router.post('/login', async (req, res) => {
//  console.log('Login request body:', req.body); // Debug
//  const { phoneEmail, password } = req.body || {};
//
//  if (!phoneEmail || !password) {
//    return res.status(400).json({ error: 'Vui lòng nhập đầy đủ thông tin' });
//  }
//
//  try {
//    const pool = await poolPromise;
//    const result = await pool.request()
//      .input('phoneEmail', sql.VarChar, phoneEmail)
//      .query('SELECT * FROM Users WHERE email = @phoneEmail OR phone = @phoneEmail');
//
//    if (result.recordset.length === 0) {
//      return res.status(400).json({ error: 'Tài khoản không tồn tại' });
//    }
//
//    const user = result.recordset[0];
//    const validPass = await bcrypt.compare(password, user.password);
//    if (!validPass) {
//      return res.status(400).json({ error: 'Mật khẩu không đúng' });
//    }
//
//    const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, { expiresIn: '1h' });
//
//    res.status(200).json({ message: 'Đăng nhập thành công', token });
//  } catch (err) {
//    console.error('Login error:', err);
//    res.status(500).json({ error: 'Đăng nhập thất bại' });
//  }
//});
