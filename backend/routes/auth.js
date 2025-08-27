const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { sql, poolPromise } = require('../config/db');


// Hàm tạo OTP mặc định (6 số 1)
const generateOTP = () => '111111';

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

router.post('/forgot-password', async (req, res) => {
  const { phoneEmail } = req.body || {};

  if (!phoneEmail) {
    return res.status(400).json({ error: 'Vui lòng nhập email hoặc số điện thoại' });
  }

  try {
    const pool = await poolPromise;
    const userResult = await pool.request()
      .input('phoneEmail', sql.VarChar, phoneEmail)
      .query('SELECT id FROM Users WHERE email = @phoneEmail OR phone = @phoneEmail');
    if (userResult.recordset.length === 0) {
      return res.status(404).json({ error: 'Tài khoản không tồn tại' });
    }

    const userId = userResult.recordset[0].id;
    const otp = '111111'; // OTP mặc định
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // Hết hạn sau 10 phút

    await pool.request()
      .input('user_id', sql.Int, userId)
      .input('otp', sql.VarChar, otp)
      .input('expires_at', sql.DateTime, expiresAt)
      .query('INSERT INTO OTPs (user_id, otp, expires_at) VALUES (@user_id, @otp, @expires_at)');

    res.status(200).json({ message: 'OTP đã được tạo (mặc định 111111)' });
  } catch (err) {
    console.error('Forgot password error:', err);
    res.status(500).json({ error: 'Khôi phục mật khẩu thất bại' });
  }
});

// Route verify OTP
router.post('/verify-otp', async (req, res) => {
  console.log('Request body:', req.body);
  const { phoneEmail, otp } = req.body || {};

  if (!phoneEmail || !otp) {
    console.log('Validation failed:', { phoneEmail, otp });
    return res.status(400).json({ error: 'Vui lòng nhập đầy đủ thông tin' });
  }

  try {
    const pool = await poolPromise;
    const userResult = await pool.request()
      .input('phoneEmail', sql.VarChar, phoneEmail)
      .query('SELECT id FROM Users WHERE email = @phoneEmail OR phone = @phoneEmail');
    console.log('User query result:', userResult.recordset);

    if (userResult.recordset.length === 0) {
      return res.status(404).json({ error: 'Tài khoản không tồn tại' });
    }

    const userId = userResult.recordset[0].id;

    // const otpResult = await pool.request()
    //   .input('user_id', sql.Int, userId)
    //   .input('otp', sql.VarChar, otp)
    //   .query('SELECT * FROM OTPs WHERE user_id = @user_id AND otp = @otp AND expires_at > GETDATE()');
    
    const otpResult = await pool.request()
        .input('user_id', sql.Int, userId)
        .input('otp', sql.VarChar, otp)
        .query('SELECT * FROM OTPs WHERE user_id = @user_id AND otp = @otp');
    console.log('OTP query result:', otpResult.recordset);
    console.log('Current time:', new Date().toISOString());
    console.log('Query condition:', { userId, otp, expires_at: 'GETDATE()' });

    if (otpResult.recordset.length === 0) {
      return res.status(400).json({ error: 'OTP không hợp lệ hoặc hết hạn' });
    }

    // await pool.request()
    //   .input('user_id', sql.Int, userId)
    //   .input('otp', sql.VarChar, otp)
    //   .query('DELETE FROM OTPs WHERE user_id = @user_id AND otp = @otp');

    res.status(200).json({ message: 'OTP hợp lệ' });
  } catch (err) {
    console.error('Verify OTP error:', err);
    res.status(500).json({ error: 'Xác thực OTP thất bại' });
  }
});

// SỬ DỤNG THƯ VIỆN bcrypt
// Route reset password
// router.post('/reset-password', async (req, res) => {
//   const { phoneEmail, newPassword } = req.body || {};

//   if (!phoneEmail || !newPassword) {
//     return res.status(400).json({ error: 'Vui lòng nhập đầy đủ thông tin' });
//   }

//   if (newPassword.length < 6) {
//     return res.status(400).json({ error: 'Mật khẩu phải có ít nhất 6 ký tự' });
//   }

//   try {
//     const pool = await poolPromise;
//     const userResult = await pool.request()
//       .input('phoneEmail', sql.VarChar, phoneEmail)
//       .query('SELECT id FROM Users WHERE email = @phoneEmail OR phone = @phoneEmail');

//     if (userResult.recordset.length === 0) {
//       return res.status(404).json({ error: 'Tài khoản không tồn tại' });
//     }

//     const userId = userResult.recordset[0].id;

//     // Hash password mới
//     const salt = await bcrypt.genSalt(10);
//     const hashedPassword = await bcrypt.hash(newPassword, salt);

//     // Update password
//     await pool.request()
//       .input('id', sql.Int, userId)
//       .input('password', sql.VarChar, hashedPassword)
//       .query('UPDATE Users SET password = @password WHERE id = @id');

//     res.status(200).json({ message: 'Reset mật khẩu thành công' });
//   } catch (err) {
//     console.error('Reset password error:', err);
//     res.status(500).json({ error: 'Reset mật khẩu thất bại' });
//   }
// });

// kHÔNG DÙNG bcrypt
router.post('/reset-password', async (req, res) => {
  const { phoneEmail, newPassword } = req.body || {};

  if (!phoneEmail || !newPassword) {
    return res.status(400).json({ error: 'Vui lòng nhập đầy đủ thông tin' });
  }

  try {
    const pool = await poolPromise;
    await pool.request()
      .input('phoneEmail', sql.VarChar, phoneEmail)
      .input('newPassword', sql.VarChar, newPassword)
      .query('UPDATE Users SET password = @newPassword WHERE email = @phoneEmail OR phone = @phoneEmail');
    res.status(200).json({ message: 'Reset mật khẩu thành công' });
  } catch (err) {
    console.error('Reset password error:', err);
    res.status(500).json({ error: 'Đặt lại mật khẩu thất bại' });
  }
});

module.exports = router;