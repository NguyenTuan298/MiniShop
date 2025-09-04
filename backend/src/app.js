const express = require('express');
const bodyParser = require('body-parser');
const authRoutes = require('../routes/auth');
const productRoutes = require('../routes/products');
const promotionsRoutes = require('../routes/promotions');
const path = require('path');


const app = express();
const port = 3000;

// Cấu hình body-parser để parse JSON
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true })); // Thêm để hỗ trợ form data (nếu cần)

// Cấu hình phục vụ static files từ thư mục public
app.use('/images', express.static(path.join(__dirname, '../public/images')));


app.use('/api/auth', authRoutes);
app.use('/api', productRoutes);
app.use('/api/promotions', promotionsRoutes);

app.listen(port, () => {
 console.log(`Server running at http://localhost:${port}`); // ✅ sửa log
 console.log('MYSQLHOST =', process.env.MYSQLHOST);
});

