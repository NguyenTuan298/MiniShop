import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/controllers/product_controller.dart';
import 'package:minishop/widgets/product_card.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: Colors.white,
      // Không dùng AppBar ở đây nữa, chúng ta sẽ tạo header tùy chỉnh
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header tùy chỉnh bao gồm logo, nút back và tiêu đề
            _buildHeader(controller),

            // 2. Lưới sản phẩm, dùng Expanded để lấp đầy không gian còn lại
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.productList.isEmpty) {
                  return const Center(
                    child: Text('Chưa có sản phẩm trong danh mục này.'),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: controller.productList.length,
                  itemBuilder: (context, index) {
                    final product = controller.productList[index];
                    return ProductCard(product: product);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget helper để xây dựng phần header tùy chỉnh
  Widget _buildHeader(ProductController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo Minishop
          // (Giả sử bạn có file logo.png trong assets/images)
          Image.asset(
            'assets/images/logo1.png',
            height: 35,
          ),
          const SizedBox(height: 8),

          // Hàng chứa nút Back và Tiêu đề
          Stack(
            alignment: Alignment.center,
            children: [
              // Tiêu đề được căn giữa bởi Stack
              Obx(
                    () => Text(
                  controller.categoryName.value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Nút Back được căn về bên trái
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}