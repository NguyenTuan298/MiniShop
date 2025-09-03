// lib/widgets/cart_item_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minishop/modules/cart/controller/cart_controller.dart';
import 'package:minishop/utils/format.dart';
import 'package:minishop/utils/theme.dart';
import 'package:minishop/data/models/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ảnh sản phẩm (tự nhận diện network/asset)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImage(item.product.imageUrl),
          ),

          const SizedBox(width: 12),

          // Tên và giá (co giãn theo chiều ngang)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  AppFormatters.formatCurrency(item.product.price), // price là double
                  style: const TextStyle(fontSize: 14, color: AppTheme.primaryColor),
                ),
              ],
            ),
          ),

          // Cột thao tác (cố định chiều rộng để tránh overflow)
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQuantityStepper(controller, item),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: () => controller.removeFromCart(item),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  splashRadius: 18,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    final isNetwork = url.startsWith('http://') || url.startsWith('https://');
    final img = isNetwork
        ? Image.network(
      url,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox(
        width: 80, height: 80, child: Icon(Icons.broken_image),
      ),
    )
        : Image.asset(
      url,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox(
        width: 80, height: 80, child: Icon(Icons.broken_image),
      ),
    );
    return img;
  }

  Widget _buildQuantityStepper(CartController controller, CartItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStepperButton(icon: Icons.remove, onPressed: () => controller.decrementItem(item)),
        Obx(() => Text(
          item.quantity.value.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )),
        _buildStepperButton(icon: Icons.add, onPressed: () => controller.incrementItem(item)),
      ],
    );
  }

  Widget _buildStepperButton({required IconData icon, required VoidCallback onPressed}) {
    return SizedBox(
      width: 28,
      height: 28,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        padding: EdgeInsets.zero,
        splashRadius: 14,
      ),
    );
  }
}
