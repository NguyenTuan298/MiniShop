import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../cart/controller/cart_controller.dart';
import '../controller/household_controller.dart';

class HouseholdView extends GetView<HouseholdView> {
  const HouseholdView({super.key});

  @override
  Widget build(BuildContext context) {
    final HouseholdController controller = Get.find<HouseholdController>();
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đồ gia dụng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return _buildProductCard(
              name: product.name,
              imageUrl: product.imageUrl,
              price: product.price,
              cartController: cartController,
            );
          },
        );
      }),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String imageUrl,
    required double price,
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${price.toStringAsFixed(0)} VNĐ',
                      style: const TextStyle(color: Colors.red),
                    ),
                    GestureDetector(
                      onTap: () {
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
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
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
