const express = require('express');
const bodyParser = require('body-parser');
const authRoutes = require('../routes/auth');

const app = express();
const port = 3000;

// Cấu hình body-parser để parse JSON
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true })); // Thêm để hỗ trợ form data (nếu cần)

app.use('/api/auth', authRoutes);

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});