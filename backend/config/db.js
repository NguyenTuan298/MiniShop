require('dotenv').config();
const mysql = require('mysql2/promise');

const dbConfig = {
  host: process.env.DB_SERVER,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
};

const pool = mysql.createPool(dbConfig);

// Kiểm tra kết nối ban đầu (không dùng .then)
pool.getConnection()
  .then(connection => {
    console.log('Connected to MySQL');
    connection.release(); // Giải phóng kết nối sau khi kiểm tra
  })
  .catch(err => {
    console.log('Database Connection Failed! Bad Config: ', err);
  });

module.exports = pool; // Xuất pool trực tiếp, không cần poolPromise