import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cart/controller/cart_controller.dart';
import '../controller/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final CartController cartController = Get.find<CartController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo1.png',
          height: 30,
          fit: BoxFit.contain,
        ),
        backgroundColor: Colors.white70,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tin nổi bật
            Text(
              'Tin nổi bật',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.newsList.map((news) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            if (news['image']!.isNotEmpty)
                              Image.asset(news['image']!),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                news['description']!,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )),

            const SizedBox(height: 16),

            // Danh mục nổi bật
            const Text(
              'Danh mục nổi bật',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryItem(Icons.phone_android, 'Điện thoại'),
                  _buildCategoryItem(Icons.computer, 'Laptop'),
                  _buildCategoryItem(Icons.watch, 'Đồng hồ'),
                  _buildCategoryItem(Icons.tv, 'Tivi'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Sản phẩm gợi ý
            const Text(
              'Sản phẩm gợi ý',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.7,
              children: [
                _buildProductCard(
                  name: 'Điện thoại iPhone',
                  image: 'assets/images/iphone.png',
                  price: '20.000.000đ',
                  cartController: cartController,
                ),
                _buildProductCard(
                  name: 'Laptop Dell',
                  image: 'assets/images/laptop_dell.png',
                  price: '18.000.000đ',
                  cartController: cartController,
                ),
                _buildProductCard(
                  name: 'Đồng hồ Casio',
                  image: 'assets/images/dongho.png',
                  price: '2.000.000đ',
                  cartController: cartController,
                ),
                _buildProductCard(
                  name: 'Tivi Samsung',
                  image: 'assets/images/tivisamsung.png',
                  price: '15.000.000đ',
                  cartController: cartController,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.blue),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String image,
    required String price,
    required CartController cartController,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(image,
                  fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(color: Colors.red)),
                    GestureDetector(
                      onTap: () {
                        // Tạm thời chỉ báo snackbar vì chưa có Product model
                        Get.snackbar(
                          'Thông báo',
                          '$name đã được thêm vào giỏ hàng',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green.withOpacity(0.8),
                          colorText: Colors.white,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
