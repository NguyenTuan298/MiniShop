require('dotenv').config();
const mysql = require('mysql2/promise');

const dbConfig = {
  host: process.env.MYSQLHOST,
  user: process.env.MYSQLUSER,
  password: process.env.MYSQLPASSWORD,
  database: process.env.MYSQLDATABASE,
  port: process.env.MYSQLPORT
};

const pool = mysql.createPool(dbConfig);

pool.getConnection()
  .then(connection => {
    console.log('Connected to MySQL');
    connection.release(); // Giải phóng kết nối sau khi kiểm tra
  })
  .catch(err => {
    console.log('Database Connection Failed! Bad Config: ', err);
  });

module.exports = pool; // Xuất pool trực tiếp, không cần poolPromise