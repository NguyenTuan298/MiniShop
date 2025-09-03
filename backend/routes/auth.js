const express = require('express');
const router = express.Router();
const pool = require('../config/db'); // Sử dụng pool trực tiếp
require('dotenv').config();
const jwt = require('jsonwebtoken');

// Hàm tạo OTP mặc định (6 số 1)
const generateOTP = () => '111111';

// Middleware kiểm tra token
router.get('/check-token', async (req, res) => {
  const token = req.headers['authorization']?.replace('Bearer ', '');
  if (!token) {
    return res.status(401).json({ error: 'Token không được cung cấp' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const [user] = await pool.query(
      'SELECT id FROM users WHERE id = ?',
      [decoded.id]
    );
    if (user.length === 0) {
      return res.status(401).json({ error: 'Người dùng không tồn tại' });
    }
    res.status(200).json({ message: 'Token hợp lệ' });
  } catch (err) {
    console.error('Check token error:', err);
    res.status(401).json({ error: 'Token không hợp lệ hoặc đã hết hạn' });
  }
});

// LOGIN
router.post('/login', async (req, res) => {
  console.log('Loaded JWT_SECRET:', process.env.JWT_SECRET); // Kiểm tra secret
  console.log('Loaded JWT_REFRESH_SECRET:', process.env.JWT_REFRESH_SECRET); // Kiểm tra refresh secret
  const { phoneEmail, password } = req.body || {};

  if (!phoneEmail || !password) {
    return res.status(400).json({ error: 'Vui lòng nhập đầy đủ thông tin' });
  }

  try {
    const [result] = await pool.query(
      'SELECT id FROM users WHERE (email = ? OR phone = ?) AND password = ?',
      [phoneEmail, phoneEmail, password]
    );
    if (result.length > 0) {
      const userId = result[0].id;
      const token = jwt.sign({ id: userId }, process.env.JWT_SECRET, { expiresIn: '1h' });
      const refreshToken = jwt.sign({ id: userId }, process.env.JWT_REFRESH_SECRET, { expiresIn: '7d' });
      console.log('Generated token:', token, 'refreshToken:', refreshToken); // Log để kiểm tra
      res.status(200).json({ message: 'Đăng nhập thành công', token, refreshToken });
    } else {
      res.status(401).json({ error: 'Tài khoản hoặc mật khẩu không đúng' });
    }
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Đăng nhập thất bại' });
  }
});

// REFRESH TOKEN
router.post('/refresh', async (req, res) => {
  const { refreshToken } = req.body || {};

  if (!refreshToken) {
    return res.status(400).json({ error: 'Refresh token không được cung cấp' });
  }

  try {
    const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
    const [user] = await pool.query(
      'SELECT id FROM users WHERE id = ?',
      [decoded.id]
    );
    if (user.length === 0) {
      return res.status(401).json({ error: 'Refresh token không hợp lệ' });
    }
    const newToken = jwt.sign({ id: decoded.id }, process.env.JWT_SECRET, { expiresIn: '1h' });
    res.status(200).json({ message: 'Token làm mới thành công', token: newToken });
  } catch (err) {
    console.error('Refresh token error:', err);
    res.status(401).json({ error: 'Refresh token không hợp lệ hoặc đã hết hạn' });
  }
});

// REGISTER
router.post('/register', async (req, res) => {
  console.log('Request body:', req.body);
  const { email, phone, password, name } = req.body || {}; // Thêm name vào destructuring

  if (!email || !password) {
    console.log('Validation failed:', { email, phone, password, name });
    return res.status(400).json({ error: 'Vui lòng nhập đầy đủ email và mật khẩu' });
  }

  try {
    // Kiểm tra email hoặc phone đã tồn tại
    const [existingUser] = await pool.query(
      'SELECT id FROM users WHERE email = ? OR phone = ?',
      [email, phone || null]
    );
    if (existingUser.length > 0) {
      return res.status(400).json({ error: 'Email hoặc số điện thoại đã tồn tại' });
    }

    // Thêm user mới với cột name
    const [result] = await pool.query(
      'INSERT INTO users (email, phone, password, name, created_at) VALUES (?, ?, ?, ?, NOW())',
      [email, phone || null, password, name || null] // Thêm name vào query và giá trị mặc định null nếu không có
    );
    const userId = result.insertId;

    res.status(201).json({ message: 'Đăng ký thành công', userId });
  } catch (err) {
    console.error('Register error:', err);
    res.status(500).json({ error: 'Đăng ký thất bại' });
  }
});

// FORGOT PASSWORD
router.post('/forgot-password', async (req, res) => {
  const { phoneEmail } = req.body || {};

  if (!phoneEmail) {
    return res.status(400).json({ error: 'Vui lòng nhập email hoặc số điện thoại' });
  }

  try {
    const [userResult] = await pool.query(
      'SELECT id FROM users WHERE email = ? OR phone = ?',
      [phoneEmail, phoneEmail]
    );
    if (userResult.length === 0) {
      return res.status(404).json({ error: 'Tài khoản không tồn tại' });
    }

    const userId = userResult[0].id;
    const otp = '111111'; // OTP mặc định
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // Hết hạn sau 10 phút

    await pool.query(
      'INSERT INTO otps (user_id, otp, expires_at) VALUES (?, ?, ?)',
      [userId, otp, expiresAt]
    );

    res.status(200).json({ message: 'OTP đã được tạo' });
  } catch (err) {
    console.error('Forgot password error:', err);
    res.status(500).json({ error: 'Khôi phục mật khẩu thất bại' });
  }
});

// VERIFY OTP
router.post('/verify-otp', async (req, res) => {
  console.log('Request body:', req.body);
  const { phoneEmail, otp } = req.body || {};

  if (!phoneEmail || !otp) {
    console.log('Validation failed:', { phoneEmail, otp });
    return res.status(400).json({ error: 'Vui lòng nhập đầy đủ thông tin' });
  }

  try {
    const [userResult] = await pool.query(
      'SELECT id FROM users WHERE email = ? OR phone = ?',
      [phoneEmail, phoneEmail]
    );
    console.log('User query result:', userResult);

    if (userResult.length === 0) {
      return res.status(404).json({ error: 'Tài khoản không tồn tại' });
    }

    const userId = userResult[0].id;
    console.log('Matched userId:', userId);

    const [sqlTime] = await pool.query('SELECT NOW() AS currentTime');
    console.log('MySQL time (NOW):', sqlTime[0].currentTime);
    console.log('Node.js time:', new Date().toISOString());

    const [otpResult] = await pool.query(
      'SELECT * FROM otps WHERE user_id = ? AND otp = ? AND expires_at > NOW()',
      [userId, otp]
    );
    console.log('OTP query result:', otpResult);

    if (otpResult.length === 0) {
      return res.status(400).json({ error: 'OTP không hợp lệ hoặc hết hạn' });
    }

    // Comment tạm thời để debug
    // await pool.query('DELETE FROM otps WHERE user_id = ? AND otp = ?', [userId, otp]);

    res.status(200).json({ message: 'OTP hợp lệ' });
  } catch (err) {
    console.error('Verify OTP error:', err);
    res.status(500).json({ error: 'Xác thực OTP thất bại' });
  }
});

// RESET PASSWORD
router.post('/reset-password', async (req, res) => {
  const { phoneEmail, newPassword } = req.body || {};

  if (!phoneEmail || !newPassword) {
    return res.status(400).json({ error: 'Vui lòng nhập đầy đủ thông tin' });
  }

  try {
    const [result] = await pool.query(
      'UPDATE users SET password = ? WHERE email = ? OR phone = ?',
      [newPassword, phoneEmail, phoneEmail]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Tài khoản không tồn tại' });
    }
    res.status(200).json({ message: 'Reset mật khẩu thành công' });
  } catch (err) {
    console.error('Reset password error:', err);
    res.status(500).json({ error: 'Đặt lại mật khẩu thất bại' });
  }
});

module.exports = router;